Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3ENVKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:10:35 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33534 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab3ENVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:10:34 -0400
Message-ID: <5192A847.1000100@lwfinger.net>
Date: Tue, 14 May 2013 16:10:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: V3.10-rc1 memory leak
References: <51912567.6090507@lwfinger.net> <1368558586.6828.53.camel@gandalf.local.home> <20130514203028.GA2997@MacBook-Pro.local>
In-Reply-To: <20130514203028.GA2997@MacBook-Pro.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 03:30 PM, Catalin Marinas wrote:
>
> I just got a patch today:
>
> https://lkml.org/lkml/2013/5/10/607
>
> which could be related. If Rusty doesn't push it I'll do. But please let
> me know if it does not solve the problem.

This patch fixes my problem. Now I can see the next new problem reported by 
kmemleak. :)

Thanks to you and Jianpeng Ma,

Larry


