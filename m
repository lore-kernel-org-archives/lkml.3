Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaAaWWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:22:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:56757 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaAaWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:22:10 -0500
Date: Fri, 31 Jan 2014 23:22:07 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
Message-ID: <20140131222207.GH21238@linutronix.de>
References: <20140125134519.GA9845@linutronix.de>
 <52E57D42.60206@pavlinux.ru>
 <52E61C52.6070104@linutronix.de>
 <52E62A05.7080802@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E62A05.7080802@pavlinux.ru>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Vasilyev | 2014-01-27 13:42:29 [+0400]:

>3) 3.10 not works at all, even without -RT patches;

I bootet 3.10.20-rt17 some time ago on an Intel Atom with EG20T chipset
(with those pch driver like pch_udc for usb gadget, pch_uart for serial
and so on). That on _was_ working. I can share the config with you from
back then if you wish.

Sebastian
