Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297Ab3CIDG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:06:58 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54549 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176Ab3CIDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1303080706310.24111@axis700.grange>
References: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
	<Pine.LNX.4.64.1303072248560.20470@axis700.grange>
	<CAKohpo=-_uzTi6QR4MnXPd5yAZFTcw-3ZZL-TAVY+drV-bDjNw@mail.gmail.com>
	<Pine.LNX.4.64.1303080706310.24111@axis700.grange>
Date: Sat, 9 Mar 2013 11:06:55 +0800
Message-ID: <CAKohpomVitj=mMmT3Z_QPgxzDyXkKN6xYReyJxO1Nc3ei=zCww@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux@arm.linux.org.uk,
        linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        robin.randhawa@arm.com, linux-arm-kernel@lists.infradead.org,
        mark.hambleton@broadcom.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 March 2013 14:11, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Also in your driver you're doing
>
>                 cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
>                 ...
>                 cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
>
> So, theoretically you could install such notifiers to adjust CPU voltages
> (using regulators too). But adding regulator calls directly to the driver
> would make it consistent with cpufreq-cpu0.c.

Yes

>  so, if this doesn't violate
> any concepts, I think, it would be good to add those when suitable systems
> appear.

That's what i thought :)
