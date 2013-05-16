Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3EPKwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:52:45 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51542 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3EPKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:52:42 -0400
MIME-Version: 1.0
In-Reply-To: <5194B836.1020808@gmail.com>
References: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com>
 <2510029.UKsn4JyZOW@avalon> <CA+V-a8tsohAyGRCn3NhwsS19X84N_xOwLB_wd0bPvyu1fLy3+g@mail.gmail.com>
 <5194B836.1020808@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 16 May 2013 16:22:20 +0530
Message-ID: <CA+V-a8s_G78tDCGebUEw_WNmOmxHzEpsNjJ2w4oTEJ=QZzqcUQ@mail.gmail.com>
Subject: Re: [PATCH RFC] media: OF: add field-active and sync-on-green
 endpoint properties
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Thu, May 16, 2013 at 4:13 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi,
>
>
> On 05/16/2013 06:53 AM, Prabhakar Lad wrote:
>>>>
[Snip]
>> May be we rename "field-active" to "fid-pol" ?
>
>
> I guess we failed to clearly describe the 'field-even-active' property then.
> It seems to be exactly what you need.
>
> It is not enough to say e.g. field-active = <1>;, because it would not have
> been clear which field it refers to, odd or even ? Unlike VSYNC, HSYNC both
> levels of the FIELD signal are "active", there is no "idle" state for FIELD.
>
> So field-even-active = <1>; means the FIELD signal at logic high level
> indicates EVEN field _and_ this implies FIELD = 0 indicates ODD field, i.e.
>
> FIELD = 0 => odd field
> FIELD = 1 => even field
>
> For field-even-active = <0>; it is the other way around:
>
> FIELD = 0 => even field
> FIELD = 1 => odd field
>
Thanks that makes it clear :)

> It looks like only "sync-on-green" property is missing. BTW, is it really
> commonly used ? What drivers would need it ?
> I'm not against making it a common property, it's just first time I see it.
>
I have comes across a decoder tvp7002 which uses it, may be Laurent/Hans/Sakari
may point much more devices.

Regards,
--Prabhakar Lad
