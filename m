Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaDRBRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:17:04 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61620 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaDRBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAOcfFMyTmQH-FwGE2YWoA76ypzBtWPYVTyi+4QpEMnrRtw8QVg@mail.gmail.com>
References: <534C3606.7010206@meduna.org>
	<534C731F.1050406@meduna.org>
	<534DADF1.6060608@meduna.org>
	<53500184.4050309@meduna.org>
	<53505BD7.9050004@meduna.org>
	<CAOcfFMyTmQH-FwGE2YWoA76ypzBtWPYVTyi+4QpEMnrRtw8QVg@mail.gmail.com>
Date: Thu, 17 Apr 2014 21:15:50 -0400
Message-ID: <CAOcfFMz6U+w_h+0GoAB4OMbEGsDo_h=vCobvgxuBtLTijW3VmQ@mail.gmail.com>
Subject: Re: BUG: spinlock trylock failure on UP - reverting timer patches helps
From: jordan <triplesquarednine@gmail.com>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey again,

> [ninez@localhost ~]$  (cat /proc/meminfo ; cat /proc/meminfo) |  grep
> KernelStack
> KernelStack:        3728 kB
> KernelStack:        3728 kB
> [ninez@localhost ~]$  (cat /proc/meminfo ; cat /proc/meminfo) |  grep
> KernelStack
> KernelStack:        3696 kB
> KernelStack:        3696 kB
>
> I'll post from my old kernel in a bit.

my other machines all report kstack as being stable/consistent - I
also had an Archlinux user of my kernel check his box - his was
consistent too. [all of those boxes reverted those timer patches].

cheerz

Jordan
