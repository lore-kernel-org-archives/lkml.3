Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3HQAIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:08:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46011 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab3HQAIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:08:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Li Yang-R58472 <r58472@freescale.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: System suspend states and device driver suspend() callback
Date: Sat, 17 Aug 2013 01:53:36 +0200
Message-ID: <35306580.ZCUI1aZasW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <02318724-F4F7-4D53-9926-872E9417F672@freescale.com>
References: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com> <17024788.0xFN8jEV59@vostro.rjw.lan> <02318724-F4F7-4D53-9926-872E9417F672@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 16, 2013 05:13:42 PM Li Yang-R58472 wrote:
> 
> 在 2013-8-16，下午7:22，"Rafael J. Wysocki" <rjw@sisk.pl> 写道：
> 
> > On Friday, August 16, 2013 04:06:26 PM Li Yang wrote:
> >> Hi Guys,
> >> 
> >> Is there a standard way for the device drivers to know if the system
> >> is going to “standby” mode or “mem” mode when the suspend() callbacks
> >> are called?
> > 
> > No, there's none.
> > 
> > What do you need that for?
> 
> Some chips like ours are putting the on-chip devices into different low
> power states when entering different system low power states.  When we enter
> system standby, on-chip devices are clock gated.  While entering suspend to
> ram, on-chip devices are power gated.  We want to driver to act differently
> too when entering different suspend states.

Can you possibly use platform suspend operations to implement that (in analogy
with ACPI suspend operations)?

Rafael

