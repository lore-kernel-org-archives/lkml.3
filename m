Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaBLUFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:05:53 -0500
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:54844 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaBLUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:05:41 -0500
Date: Wed, 12 Feb 2014 20:58:16 +0100
From: Martin Mares <mj@ucw.cz>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb
 support
Message-ID: <mj+md-20140212.194230.3341.nikam@ucw.cz>
References: <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
 <mj+md-20131110.114139.9646.albireo@ucw.cz>
 <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
 <mj+md-20131215.091609.28546.nikam@ucw.cz>
 <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
 <mj+md-20131215.110132.29802.nikam@ucw.cz>
 <CAG-2HqUGcBB1-YUvLZpqm1EZ69OSksa+iGcCEqVWxYsehDqx8Q@mail.gmail.com>
 <CAG-2HqWYZtTMNRvLwWRy-5_5yb=EasiWzpL2xc0_42SyP=bg1w@mail.gmail.com>
 <CAG-2HqVS1avGdvi6SFc1dq0sCzcA4z5sZUBH4WhpNN87tZrnxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqVS1avGdvi6SFc1dq0sCzcA4z5sZUBH4WhpNN87tZrnxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ping?

Sorry for the delay, I was alternatingly ill and overloaded with other stuff...

As I said before, I do not like the current implementation of hwdb much (it's
too much tied to Linux, and hardware description strings, originally intended
for internal use between the kernel and its modules, are far from a nice API).

I would prefer a more general HW identification library and I am willing to
write it, but I have to admit that with my current load, it will be hardly
finished before this summer.

I will merge your patches. It's better to have the current hwdb than nothing.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
First law of socio-genetics: Celibacy is not hereditary.
