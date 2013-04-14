Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3DNAm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 20:42:56 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64291 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3DNAmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 20:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <tip-a1a04ec3c7c27a682473fd9beb2c996316a64649@git.kernel.org>
References: <20130321215233.583190032@linutronix.de>
	<tip-a1a04ec3c7c27a682473fd9beb2c996316a64649@git.kernel.org>
Date: Sat, 13 Apr 2013 17:42:54 -0700
X-Google-Sender-Auth: dSnkrKuWnlG5a2asGkoPXuTrS7Q
Message-ID: <CAE9FiQV8aATG8sK=ZbxD0N3V3p5Je7Rm2mEbbXYXmU4pnWNeMQ@mail.gmail.com>
Subject: Re: [tip:smp/hotplug] idle: Provide a generic entry point for the
 idle code
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 1:12 PM, tip-bot for Thomas Gleixner
<tipbot@zytor.com> wrote:
> Commit-ID:  a1a04ec3c7c27a682473fd9beb2c996316a64649
> Gitweb:     http://git.kernel.org/tip/a1a04ec3c7c27a682473fd9beb2c996316a64649
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Thu, 21 Mar 2013 22:49:34 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 8 Apr 2013 17:39:23 +0200
>
> idle: Provide a generic entry point for the idle code
>
> For now this calls cpu_idle(), but in the long run we want to move the
> cpu bringup code to the core and therefor we add a state argument.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
...
> Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

What is that ?

looks your scripts has problem to convert Cc to Reviewed-by

Yinghai
