Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765335Ab3DKWpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:45:12 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58406 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3DKWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:45:10 -0400
MIME-Version: 1.0
In-Reply-To: <51666AE8.9060602@ti.com>
References: <515D2D30.3000306@ti.com>
	<20130404164137.GH10155@atomide.com>
	<515EA9E3.1010409@ti.com>
	<20130405155851.GA10155@atomide.com>
	<5163E589.1040809@ti.com>
	<20130409164928.GL10155@atomide.com>
	<20130409174319.GP10155@atomide.com>
	<20130409204900.GA8815@kahuna>
	<20130410080630.14359.68178@quantum>
	<5165453E.6090503@ti.com>
	<20130410173921.GA31017@kahuna>
	<51666AE8.9060602@ti.com>
Date: Thu, 11 Apr 2013 17:45:08 -0500
X-Google-Sender-Auth: z4qq1T6Ke30oq_YzsQfWF6BghwM
Message-ID: <CAGo_u6ooB3W6kN6mP7qnrRDPLo-+oasTrg6F=BRdiW2bVVGcZw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for AUXCLKs
From: Nishanth Menon <nm@ti.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>, Tony Lindgren <tony@atomide.com>,
        linux-usb@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, balbi@ti.com,
        grygorii.strashko@ti.com, linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 2:48 AM, Roger Quadros <rogerq@ti.com> wrote:
> On 04/10/2013 08:39 PM, Nishanth Menon wrote:
>> On 13:55-20130410, Roger Quadros wrote:
>>> On 04/10/2013 11:06 AM, Mike Turquette wrote:
>>>> Quoting Nishanth Menon (2013-04-09 13:49:00)
>> Folks, this does seem to be the best compromise we can achieve at this
>> point in time. feedback on this approach is much appreciated - if folks
>> are ok, I can post this as an formal patch series.
>
> This looks fine to me. Minor comments below.
Thanks on the review. will fix in my next post
Regards,
Nishanth Menon
