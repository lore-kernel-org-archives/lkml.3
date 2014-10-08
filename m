Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaJHVmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:42:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56633 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754845AbaJHVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:42:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bryan Wu <cooloney@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 12/13] leds: leds-gpio: Make use of device property API
Date: Thu, 09 Oct 2014 00:02:08 +0200
Message-ID: <2998434.5IT5NjTfu8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAK5ve-JTri0ML23gdXTgfRPh+tkJGUj6jHcjEKEVNphwG-PQjw@mail.gmail.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <2960802.kPr8UT7PvT@vostro.rjw.lan> <CAK5ve-JTri0ML23gdXTgfRPh+tkJGUj6jHcjEKEVNphwG-PQjw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 08, 2014 10:47:16 AM Bryan Wu wrote:
> On Wed, Oct 8, 2014 at 7:04 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, October 07, 2014 02:18:45 AM Rafael J. Wysocki wrote:
> >> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> Make use of device property API in this driver so that both OF and ACPI
> >> based system can use the same driver.
> >>
> >> This change contains material from Max Eliaser and Mika Westerberg.
> >>
> >> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Bryan, can you please tell me if you are OK with this patch?
> >
> > You said you were for one of the previous versions if I remember correctly,
> > but it's changed quite a bit since then, so can you please check this new
> > version too?
> >
> 
> Sure, the new one is even better than before. Please go ahead with my Ack
> Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks!

