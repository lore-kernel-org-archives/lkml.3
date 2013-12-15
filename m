Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3LOLdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 06:33:35 -0500
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:57777 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab3LOLde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 06:33:34 -0500
Date: Sun, 15 Dec 2013 12:33:32 +0100
From: Martin Mares <mj@ucw.cz>
To: Kay Sievers <kay@vrfy.org>
Cc: Tom Gundersen <teg@jklm.no>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb
 support
Message-ID: <mj+md-20131215.110132.29802.nikam@ucw.cz>
References: <1378302428-19758-1-git-send-email-teg@jklm.no>
 <mj+md-20130904.134928.12262.nikam@ucw.cz>
 <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
 <mj+md-20131110.114139.9646.albireo@ucw.cz>
 <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
 <mj+md-20131215.091609.28546.nikam@ucw.cz>
 <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> It does that per process doing that, and that's the problem for how
> udev works/worked. The binary hwdb is on-disk and can be mmaped, and
> there is no difference between initialization, first, or subsequent
> queries.

OK, point taken.

I see that a mechanism for fast lookup of hardware identification data
is needed. However, why should such a mechanism depend on udev, systemd,
or Linux in general?

What I would really like to have is a universal library for HW lookup,
independent of anything else and widely portable. All the hardware data
would be provided by other packages -- pci.ids, usb.ids, kernel modules,
etc. -- and compiled to a binary format available for instant queries.

Do I miss anything?

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
A half-joke: What is the difference between a cat?
