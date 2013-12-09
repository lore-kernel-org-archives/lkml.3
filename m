Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417Ab3LIDmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:42:54 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58037 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368Ab3LIDmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:42:51 -0500
Message-ID: <52A53C3A.2090107@gmail.com>
Date: Sun, 08 Dec 2013 20:42:50 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A5DFC9.6020105@cn.fujitsu.com>
In-Reply-To: <52A5DFC9.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/13, 8:20 AM, Dongsheng Yang wrote:
> How about introduce an option named --guestpid? Then we can make the
> usage of perf kvm
> more clear:
>      * perf kvm --guestkallsyms --guestmodules --guestpid
> [top|record|report]
>          This usage is for only one guest and will not resolve the
> symbols from other guests.

If there is only 1 guest then there should not be a problem right? You 
give perf a single guest kallsyms as the "default" and it works. 
--guestpid adds no value in that case.

David


