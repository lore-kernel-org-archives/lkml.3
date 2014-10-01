Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaJAIFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:05:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57669 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJAIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:05:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 08/15] leds: leds-gpio: Add support for GPIO descriptors
Date: Wed, 01 Oct 2014 10:05:34 +0200
Message-ID: <353412292.4KkPI9NZaJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1490183.QvrzPxsV7q@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <1490183.QvrzPxsV7q@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mPIpv7ilTM9XwtWkDEisq8rNlH50QyDInIPc1/LbGjK
 /JT/agn29UvQeN4vfDQyC9A7lxtK9hS3EUn0AF69sg64+FIuv/
 LAQQ0+/tSM46UPgz8UpIUklKCR8etdKMXcipubn+GwfSNh1ior
 Vc9AD87boPqASwmvvBail9RqYgI3tJ5ofijIVXlKv4B78C+/P5
 siL2lNXhuGycWRt7QdrTJzHzOTr2hl6oyR3/KDKdliw7cBG8kl
 lnnOyI1BOAjWA4l8U0EZ2/taUb7UYlxA+gS9cuAh4UtHrAwvRz
 P6P67MaTh7sCe2SNzX2plN7hS2JhcybyH/3sOWJEFKQDnR2TmW
 MaoDK+akkgv21WVtoqzE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:15:41 Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> GPIO descriptors are the preferred way over legacy GPIO numbers
> nowadays. Convert the driver to use GPIO descriptors internally but
> still allow passing legacy GPIO numbers from platform data to support
> existing platforms.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Bryan Wu <cooloney@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

Nice!

Acked-by: Arnd Bergmann <arnd@arndb.de>
