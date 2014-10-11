Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaJKKhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 06:37:22 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:40941 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJKKhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:37:19 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sat, 11 Oct 2014 12:34:32 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] ARM: dts: am335x-bone-common: enable power off and
 rtc wake up
Message-ID: <20141011103432.GF18988@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-13-git-send-email-johan@kernel.org>
 <20141010180941.GZ31348@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010180941.GZ31348@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:09:49PM -0500, Felipe Balbi wrote:
> On Thu, Oct 09, 2014 at 09:06:34PM +0200, Johan Hovold wrote:
> > Configure the RTC as system-power controller, which allows the system to
> > be powered off as well as woken up again on subsequent RTC alarms.
> > 
> > Note that the PMIC needs to be put in SLEEP (rather than OFF) mode to
> > maintain RTC power. Specifically, this means that the PMIC
> > ti,pmic-shutdown-controller property must be left unset in order to be
> > able to wake up on RTC alarms.
> > 
> > Tested on BeagleBone Black (rev A5).
> 
> one thing though. IIRC, rtc-only mode does not work with ES1.0 and
> beagle-bone white uses that. Perhaps move this from bone-common to
> boneblack.dts ?

Yeah, I had a quick look at the errata and you seem to be correct. I'll
move it to boneblack.dts.

> other than that
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Thanks,
Johan
