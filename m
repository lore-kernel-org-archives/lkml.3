Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3LJGC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:02:58 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34864 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3LJGCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:02:55 -0500
Message-ID: <52A6AE87.3040706@gmail.com>
Date: Mon, 09 Dec 2013 23:02:47 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A4AED8.3000506@gmail.com> <20131209180705.GB8098@ghostprotocols.net> <52A60705.5030303@gmail.com> <20131209184901.GE8098@ghostprotocols.net> <52A61D43.6020007@gmail.com> <52A7637E.8080007@cn.fujitsu.com>
In-Reply-To: <52A7637E.8080007@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13, 11:54 AM, Dongsheng Yang wrote:
> Okey, David, I saw your commit 207b57926 (perf kvm: Fix regression with
> guest machine creation) here. It is applied to fix a bug of SEGFAULT. I
> have to say that it changed the behavior of report and lead to current bug.


Dongsheng, I appreciate your perseverance here. I am trying to survive 
this week due to a lot of demands on my time. Next week or the week 
after I will revisit your questions and comments on perf-kvm.

David
