Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3IKIjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:39:40 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:34292 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3IKIjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:39:37 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1309111015190.26942@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
	<CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
	<Pine.LNX.4.64.1309101656150.16010@axis700.grange>
	<CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
	<Pine.LNX.4.64.1309101740120.16010@axis700.grange>
	<CAKohpomK7Y_6aLMA3B+hZrtgYq9U89ihgkbvYWA3BsKN3gJD3g@mail.gmail.com>
	<Pine.LNX.4.64.1309101853170.16010@axis700.grange>
	<CAKohpokaHU0V86DPB7nEQ8ndwu_mJ_x_Uz47XPHZeyAW3hcP_w@mail.gmail.com>
	<Pine.LNX.4.64.1309111015190.26942@axis700.grange>
Date: Wed, 11 Sep 2013 14:09:35 +0530
Message-ID: <CAKohpomA0s_gCZncbfGK9YN3HhRuoswQ5xo71=A3a7t_PbEKOw@mail.gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2013 13:45, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> I'd rather wait until Rafael is convinced, then we'll see.

Okay.. I have just sent a mail to Rafael about that, see if you
are convinced with what I wrote :)

--
viresh
