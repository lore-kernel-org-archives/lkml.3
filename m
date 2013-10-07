Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3JGL5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:57:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51158 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751369Ab3JGL5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:57:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 2/4] ACPI / video: seperate backlight control and event interface
Date: Mon, 07 Oct 2013 14:09:16 +0200
Message-ID: <2575044.XfDRT53jVt@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5241616D.9040305@intel.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com> <1380016052-15315-3-git-send-email-aaron.lu@intel.com> <5241616D.9040305@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 24, 2013 05:54:53 PM Aaron Lu wrote:
> On 09/24/2013 05:47 PM, Aaron Lu wrote:

[...]

> > diff --git a/include/acpi/video.h b/include/acpi/video.h
> > index 61109f2..0c665b5 100644
> > --- a/include/acpi/video.h
> > +++ b/include/acpi/video.h
> > @@ -19,11 +19,13 @@ struct acpi_device;
> >  #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> >  extern int acpi_video_register(void);
> >  extern void acpi_video_unregister(void);
> > +extern int acpi_video_unregister_backlight(void);
> 
> Oops, forgot to remove the declration and the stub below. But it doesn't
> affect the test of the patches, so I'll leave it for a while till next
> revision.

Any chance to send the next revision?

Rafael

