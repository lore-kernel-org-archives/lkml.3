Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3LKT4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:56:33 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53436 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3LKT4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:56:32 -0500
Message-ID: <52A8C36A.9000501@gmail.com>
Date: Wed, 11 Dec 2013 12:56:26 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf completion: complete 'perf kvm'
References: <1386758056-24618-1-git-send-email-artagnon@gmail.com> <1386758056-24618-2-git-send-email-artagnon@gmail.com> <20131211195046.GA2295@infradead.org>
In-Reply-To: <20131211195046.GA2295@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 12:50 PM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 11, 2013 at 04:04:15PM +0530, Ramkumar Ramachandra escreveu:
>> Currently, there is no way to enumerate the subcommands under 'perf
>> kvm', so hardcode them.
>
> [acme@ssdandy linux]$ perf kvm -h 2>&1 | grep usage
>   usage: perf kvm [<options>] {top|record|report|diff|buildid-list|stat}
>
> Can't you use this somehow?
>
> I'm applying it tho as it is better than the current situation.

I don't like the command list being embedded in the completion script. 
It will get outdated quickly.

David


