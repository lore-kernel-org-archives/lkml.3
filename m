Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab3GSPpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:45:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40308 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3GSPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:45:15 -0400
Message-ID: <51E95F0B.6080703@sgi.com>
Date: Fri, 19 Jul 2013 10:45:15 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Holger Hans Peter Freyther <holger@freyther.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: /proc/timer_list and weird behavior with dropbear
References: <20130719152800.GA20792@xiaoyu.lan>
In-Reply-To: <20130719152800.GA20792@xiaoyu.lan>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 10:28 AM, Holger Hans Peter Freyther wrote:
> Dear Nathan,
>
> I am currently upgrading a kernel for a TI Davinci DM644x based design
> from Linux 3.2 to Linux 3.10.1. I have a funny re-producible issue that
> goes away by reverting b3956a896ea57f25cacd74708b8fab611543a81d.
>
> The dropbear sshd will open several files after accepting a connection to
> generate some entropy. The "/proc/timer_list" file is part of that[1].
> It will open that file and will try to read until the end of the file, but
> most of the time this end never comes. According to strace the read on the
> fd will always return 2048. I have attached the testcase I am using to
> re-produce the issue.
>
> Can this be re-produced by anyone else?
>
> holger
>
>
>
> [1] https://secure.ucc.asn.au/hg/dropbear/file/028fa77f952f/random.c#l204
>
I hadn't noticed anything.
Let me try your program and see what I may have missed.
