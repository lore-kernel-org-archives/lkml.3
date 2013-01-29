Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3A2XJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:09:03 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35881 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3A2XJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:09:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130129160243.GA3389@kahuna>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
	<20130129160243.GA3389@kahuna>
Date: Wed, 30 Jan 2013 01:08:59 +0200
Message-ID: <CAB=otbSV6CH4WOrr577bHXFcjEVRGjZxatgy4CJ3cr0M0h4vfw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ARM: update cpuinfo to print CPU model name
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 29, 2013 at 6:02 PM, Nishanth Menon <nm@ti.com> wrote:
>
> On 17:54-20130129, Ruslan Bilovol wrote:
> > Hi,
> >
> > The following patches update cpuinfo to print CPU
> > model name for ARM. First patch exactly makes needed
> > changes for ARM architecture.
> > Second patch adds this ability to OMAP4 SoCs.
> >
> > This adds a common approach to show SoC name.
> >
> > Looks like there were few attempts to do similar
> > changes to cpuinfo without any luck.
> >
> > So - comments are welcome
> >
> > Ruslan Bilovol (2):
> >   ARM: kernel: update cpuinfo to print CPU model name
> >   ARM: OMAP4: setup CPU model name during ID initialisation
>
> We had an discussion on similar lines but a generic suggestion:
> https://patchwork.kernel.org/patch/98720/
> SoCinfo framework which was supposed to introduce this
>
> Would'nt that be a better approach to take than an OMAP only solution?

My goal is only to say what is the SoC model name in the /proc/cpuinfo
(And it is not an OMAP-only solution - it is common. Support for OMAP
is added in second patch)
This is the only type of information that we can apply for any SoC.
My point is - any SoC-specific information should go through some other
way - like SoCinfo framework mentioned by you.
And additional point - in cpuinfo we already have CPU name and Machine name.
The SoC name (that is something between these two things) looks also relevant

>
> Ccying eduardo who had driven this for some time.

Yes, let's have additional comments

> --
> Regards,
> Nishanth Menon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
