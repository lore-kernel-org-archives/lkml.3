Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaEINMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:12:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:35786 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaEINMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:12:46 -0400
Date: Fri, 9 May 2014 15:12:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: minyard@acm.org
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] ftrace: Simplify ring buffer resizing, make work with RT
Message-ID: <20140509131244.GF29014@linutronix.de>
References: <1399579402-27034-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399579402-27034-1-git-send-email-minyard@acm.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* minyard@acm.org | 2014-05-08 15:03:22 [-0500]:

>This isn't well tested, but fixes an obvious PREEMPT_RT problem and seems
>like a good simplification.  You can see the PREEMPT_RT bug if you enable
>ftrace and all the self tests; it will fail running selftests when it tries
>to resize the buffers.

I posted http://marc.info/?l=linux-rt-users&m=139962823022896&w=2 before
I noticed this one. You seem not to touch the second hunk.

Sebastian
