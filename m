Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3HLIOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:14:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:42780 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3HLIOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:14:41 -0400
Date: Mon, 12 Aug 2013 10:14:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
Message-ID: <20130812081430.GA23040@linutronix.de>
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
 <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com>
 <1375419917.3743.93.camel@pasglop>
 <51FBA9CC.2090206@linutronix.de>
 <20130802141936.GA8267@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130802141936.GA8267@windriver.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Gortmaker | 2013-08-02 10:19:36 [-0400]:

>The list of donor victims that aren't used in asm is getting
>smaller, but TIF_POLLING_NRFLAG seems OK and it puts RESCHED
>and RESCHED_LAZY right beside each other.

Applied & merged into the original patch. Thanks.

>Thanks guys,
>Paul.

Sebastian
