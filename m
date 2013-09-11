Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3IKIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:16:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3IKIQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:16:23 -0400
Date: Wed, 11 Sep 2013 10:15:53 +0200 (CEST)
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
Message-ID: <Pine.LNX.4.64.1309111015190.26942@axis700.grange>
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
X-Provags-ID: V02:K0:idDLe6IvfiwMVLF2srmxTCgBDzm58ev9/bmRBAmf0Dg
 2caRwppURSzVj1+SzAjW4zxqVlpEDhLe2IvXerQDQ1ZaqlCEqu
 A7b9fEjTFtwW1s+YzLs8yOjz4zSe1g24ZjUvxEqlPhaq6387w1
 v5Vfv4qUQfkHC9FK8G3a2OwCaAgCDV4iCFleed0dUGmms9ZhIM
 pEcQjmbIrfijKQ2N0gZjKxiNuP2YMspJZYzlvlIDz9E3+Kmxsg
 iAcO4tq4JFUZusGLPDjCYWwCQw9+bT8HhfVnoK2eYMw5qJyvz2
 +vGjldj6p0seQUKRCm4Az2dbjF1lvWViXEvn76kHTStmF1uU6g
 QnR/gfrIEP94ZfZVFFHnW0WSsCdlri0bpbF0yL8n3E2+DLp91U
 LgxG/07c4VBMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I'd rather wait until Rafael is convinced, then we'll see.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
