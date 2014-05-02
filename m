Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaEBKQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:16:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:39572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEBKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:16:47 -0400
Date: Fri, 2 May 2014 12:16:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140502101646.GD9178@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
 <1397918766.5436.16.camel@marge.simpson.net>
 <1398051078.4437.6.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398051078.4437.6.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-04-21 05:31:18 [+0200]:

>Another little bug.  This hunk of patches/stomp-machine-raw-lock.patch
>should be while (atomic_read(&done.nr_todo)) 

Thanks, fixed up.

Sebastian
