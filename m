Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaKDW3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:29:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60856 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751303AbaKDW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:29:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] leds: leds-gpio: Convert gpio_blink_set() to use GPIO descriptors
Date: Tue, 04 Nov 2014 23:50:33 +0100
Message-ID: <2455157.3p7mHhT8im@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545843B1.3020101@nvidia.com>
References: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com> <545843B1.3020101@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 12:10:41 PM Alexandre Courbot wrote:
> On 10/31/2014 08:40 PM, Mika Westerberg wrote:
> > Commit 21f2aae91e902aad ("leds: leds-gpio: Add support for GPIO
> > descriptors") already converted most of the driver to use GPIO descriptors.
> > What is still missing is the platform specific hook gpio_blink_set() and
> > board files which pass legacy GPIO numbers to this driver in platform data.
> >
> > In this patch we handle the former and convert gpio_blink_set() to take
> > GPIO descriptor instead. In order to do this we convert the existing four
> > users to accept GPIO descriptor and translate it to legacy GPIO number in
> > the platform code. This effectively "pushes" legacy GPIO number usage from
> > the driver to platforms.
> >
> > Also add comment to the remaining block describing that it is legacy code
> > path and we are getting rid of it eventually.
> >
> > Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied, thanks everyone!

