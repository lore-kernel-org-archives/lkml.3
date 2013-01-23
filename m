Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3AWOZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:25:49 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:36635 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3AWOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA911BF@DBDE01.ent.ti.com>
References: <cover.1358871750.git.afzal@ti.com>
	<02F0A27B-B16B-42F8-A0BC-29726732226D@dominion.thruhere.net>
	<CAF6AEGuyb26EZ_9=GP9gs0TZqUtiFv3D_7+wcDOHuKn2qUcytQ@mail.gmail.com>
	<C8443D0743D26F4388EA172BF4E2A7A93EA911BF@DBDE01.ent.ti.com>
Date: Wed, 23 Jan 2013 08:25:46 -0600
Message-ID: <CAF6AEGtOzKNn0jJ+KPdx6kZOGdw6M2u6xm34Qq9X6SHpGZe51A@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] video: da8xx-fb: am335x DT support
From: Rob Clark <robdclark@gmail.com>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: Koen Kooi <koen@dominion.thruhere.net>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 6:27 AM, Mohammed, Afzal <afzal@ti.com> wrote:
> Hi,
>
> On Wed, Jan 23, 2013 at 00:15:09, Rob Clark wrote:
>
>> > Wouldn't it be better to delete da8xx-fb.* and switch to Rob Clarks DRM based driver for this IP block?
>
>> we probably can't delete da8xx-fb, but I think it would be ok to only
>> use it for legacy platforms not yet ported to DT.
>
> We can't remove da8xx-fb as DA830 is a non-DT one and DA850 is only gaining
> DT support.
>
> And Rob,
>
> I am not familiar with drm setup, would all the user space frame buffer based
> applications work as is with drm driver?

drm does provide a legacy fbdev interface (needed for fbcon, for
example).  I don't think da8xx-fb has any custom ioctls, so probably
what drm provides should be enough.

BR,
-R

> Regards
> Afzal
