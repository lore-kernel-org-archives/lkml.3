Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3FQDDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:03:11 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3FQDDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:03:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 0/5] pinctrl: fix some issues with new pinconfig dt parsing
Date: Mon, 17 Jun 2013 05:03:22 +0200
Message-ID: <2162180.An6kI8rHhm@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51BB3C62.4070000@imgtec.com>
References: <201306141741.46077.heiko@sntech.de> <51BB3C62.4070000@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Friday 14 June 2013 16:53:06 James Hogan wrote:
> On 14/06/13 16:41, Heiko Stübner wrote:
> > Some issues with the recently submitted generic pinconfig parsing from dt
> > came up, so fix these in this follow-up series.
> > 
> > Hopefully I did catch all of them.
> > 
> > Tested on my rk3066 device.
> > 
> > Heiko Stuebner (5):
> >   pinctrl: update the documentation for some pinconfig params
> >   pinctrl: clarify some dt pinconfig options
> >   pinctrl: handle zero found dt pinconfig properties better
> >   pinctrl: dynamically alloc temp array when parsing dt pinconf options
> 
> patches 1-4:
> Reviewed-by: James Hogan <james.hogan@imgtec.com>

Probably too late as Linus has already applied the patches, but for 2, 3 and 4

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

