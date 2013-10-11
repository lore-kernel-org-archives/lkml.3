Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3JKKSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:18:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:60272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3JKKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:18:07 -0400
Date: Fri, 11 Oct 2013 12:18:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Clark Williams <williams@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: Re: [Intel-gfx] BUG: sleeping function called from invalid context
 on 3.10.10-rt7
Message-ID: <20131011101800.GE6983@linutronix.de>
References: <5230895B.5070400@hurleysoftware.com>
 <20130911113845.6d56a556@gandalf.local.home>
 <5230C52E.3050801@hurleysoftware.com>
 <5238B288.3000704@hurleysoftware.com>
 <CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com>
 <523CC728.4040302@tuebingen.mpg.de>
 <20130923083841.GT4531@intel.com>
 <5242674A.8020100@tuebingen.mpg.de>
 <20130925101301.6cbe5d0f@gandalf.local.home>
 <52445DEF.1060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52445DEF.1060007@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mario Kleiner | 2013-09-26 18:16:47 [+0200]:

>Good! I will do that. Thanks for clarifying the irq and constraints
>on raw locks in the other thread.

Are there any suggestions for "now"?  preempt_disable_nort() like Luis
suggesed?

>-mario

Sebastian
