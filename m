Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaBGWbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:31:46 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:37945 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaBGWbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:31:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402071721350.21991@ionos.tec.linutronix.de>
References: <1391721117-27446-1-git-send-email-carlo@caione.org>
	<alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de>
	<CAOQ7t2Z0agZdDZ_OQZPtXWXoi5NMTcOOZz04q6wEVNy0rxn4AA@mail.gmail.com>
	<alpine.DEB.2.02.1402062229000.21991@ionos.tec.linutronix.de>
	<CAOQ7t2bzz9vKh_5h2nF=m+JpeYVa=Ttd4XQgrAa6Lhdzjg_Qxw@mail.gmail.com>
	<alpine.DEB.2.02.1402071121310.21991@ionos.tec.linutronix.de>
	<CAOQ7t2b5qVTUXOB4iWAOoTehm=u6zxP0-zQmirSF0DvEk8KddQ@mail.gmail.com>
	<alpine.DEB.2.02.1402071721350.21991@ionos.tec.linutronix.de>
Date: Fri, 7 Feb 2014 23:31:43 +0100
Message-ID: <CAOQ7t2ZfdjuDhtFVz-JvVA_UkGSPzpPAAv9ExZo6UGeshNBwfA@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH] irq: Add new flag to ack
 level-triggered interrupts before unmasking
From: Carlo Caione <carlo.caione@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans De Goede <hdegoede@redhat.com>, emilio@elopez.com.ar,
        linux-sunxi@googlegroups.com, t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 6:24 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Not sure, really, but I tend to a core patch. Though we really want to
> know whether the issue is threaded only or not. If it's a general
> issue then this wants to go into unmask_irq() itself and not into an
> extra unmask_threaded_irq() function.

Unfortunately I cannot be sure whether the problem is still present
for the non threaded case since in the hardware I have the NMI
controller is only connected to the PMIC.
Considering that I have no way of checking what do you suggest?

-- 
Carlo Caione
