Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaA0IoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:44:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:37279 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaA0IoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:44:06 -0500
Message-ID: <52E61C52.6070104@linutronix.de>
Date: Mon, 27 Jan 2014 09:44:02 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: pavel@pavlinux.ru
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
References: <20140125134519.GA9845@linutronix.de> <52E57D42.60206@pavlinux.ru>
In-Reply-To: <52E57D42.60206@pavlinux.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 10:25 PM, Pavel Vasilyev wrote:
> 25.01.2014 17:45, Sebastian Andrzej Siewior пишет:
>> Dear RT folks!
> 
> 
> Gentlemen, let's have a month of stress testing! Divide tasks
> testing subsystem: USB, NET, MM, ACPI, AUDIO, VIDEO By CPUs:
> ARM/PPC/X86/X86_64...
> 
> Purely on observations noted that in September 2013, the quality
> and stability of the code has deteriorated dramatically.

By September 2k13, do you mean a specific v3.10-RT release?

Sebastian
