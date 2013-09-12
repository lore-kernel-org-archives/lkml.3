Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3ILHsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:48:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3ILHsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:48:22 -0400
Date: Thu, 12 Sep 2013 09:47:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
In-Reply-To: <CAKohpokaHU0V86DPB7nEQ8ndwu_mJ_x_Uz47XPHZeyAW3hcP_w@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1309120938240.4632@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
 <CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
 <Pine.LNX.4.64.1309101656150.16010@axis700.grange>
 <CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
 <Pine.LNX.4.64.1309101740120.16010@axis700.grange>
 <CAKohpomK7Y_6aLMA3B+hZrtgYq9U89ihgkbvYWA3BsKN3gJD3g@mail.gmail.com>
 <Pine.LNX.4.64.1309101853170.16010@axis700.grange>
 <CAKohpokaHU0V86DPB7nEQ8ndwu_mJ_x_Uz47XPHZeyAW3hcP_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:u3bYhR4WbdtylcHqjr2whtUlv36Js5YEmr1vDCzlzFl
 B48OHIdiLlqdIa/SXUBYFDGgQbe8xSYt/9yEUXxreaxLCKh31l
 GmJFWXvPHy986kh9AEL5pzhWdJaXxaDvmASPOCvcdvlE2Y43tG
 Qt+Ti97K2yP/IiMcrYIxQcYWlD6zWpepJAqDqDlzxsTF4/Aru3
 wN29aXVUbVOTOGjNXf2XZaOam0Fr7jcgK3cfa9FPOME648S4PJ
 osrwVB3q7Ck7spxv9uD6RZSMfQsan2rcgcLCpPodHo1rgmHuRQ
 b35nsHQHgkA6ygTmw7qYj/cSOX4uLeuLkRwT056Y+4e9jAy98b
 PkBdq4CTzONY+BwRgatBJQriayAFzTPDKsdvcyLk6hwnb23Skg
 U9tQMT5pMKg/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh

On Wed, 11 Sep 2013, Viresh Kumar wrote:

> On 10 September 2013 22:37, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Tue, 10 Sep 2013, Viresh Kumar wrote:
> >> Quite straight forward actually..
> >
> > Apparently, not quite.
> 
> I overlooked the situation where we return early from ->target() routines.. :(
> 
> Please try attached patches, I will repost them later (once I am able to
> convince Rafael that these are really important :) )

Yes, they seem to fix my issues. You probably aren't going to submit them 
in this form, instead, merge them with the original serialisation fix 
patch, right? So, you don't need my tested-by here. But feel free to cc me 
when you submit a fixed version.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
