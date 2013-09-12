Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3ILHvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:51:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48737 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3ILHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1309120938240.4632@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
	<CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
	<Pine.LNX.4.64.1309101656150.16010@axis700.grange>
	<CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
	<Pine.LNX.4.64.1309101740120.16010@axis700.grange>
	<CAKohpomK7Y_6aLMA3B+hZrtgYq9U89ihgkbvYWA3BsKN3gJD3g@mail.gmail.com>
	<Pine.LNX.4.64.1309101853170.16010@axis700.grange>
	<CAKohpokaHU0V86DPB7nEQ8ndwu_mJ_x_Uz47XPHZeyAW3hcP_w@mail.gmail.com>
	<Pine.LNX.4.64.1309120938240.4632@axis700.grange>
Date: Thu, 12 Sep 2013 13:21:40 +0530
Message-ID: <CAKohpokJJOxKHhyqDRRZnp_Fwc2oXZcUR7KeMF_Zegoqpo_MqA@mail.gmail.com>
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

On 12 September 2013 13:17, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Yes, they seem to fix my issues.

Great!!

> You probably aren't going to submit them
> in this form, instead, merge them with the original serialisation fix
> patch, right? So, you don't need my tested-by here. But feel free to cc me
> when you submit a fixed version.

I will add your tested-by as you have eventually test all three patch that I
would merge :)

Thanks for testing this..
