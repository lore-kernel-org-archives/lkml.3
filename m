Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3JCRSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:18:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44316 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3JCRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:18:53 -0400
Message-ID: <524DA6F9.9000608@gmail.com>
Date: Thu, 03 Oct 2013 11:18:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf tool: more user-friendly errors from trace
References: <1380788891-31908-1-git-send-email-artagnon@gmail.com> <20131003165832.GA2436@ghostprotocols.net>
In-Reply-To: <20131003165832.GA2436@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/13 10:58 AM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 03, 2013 at 01:58:11PM +0530, Ramkumar Ramachandra escreveu:
>> Currently, execution of 'perf trace' reports the following cryptic
>> message to the user:
>>
>> $ perf trace
>> Couldn't read the raw_syscalls tracepoints information!
>>
>> Now, it prints a detailed message:
>
> What about the one attached instead? It

Isnt' strerror(errno) preferred over sys_errlist[errno]?

David

