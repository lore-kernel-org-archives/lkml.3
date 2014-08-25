Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaHYIMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:12:30 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59286 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaHYIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:12:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
Date: Mon, 25 Aug 2014 10:12:10 +0200
Message-ID: <2336240.173zr5MfQE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-26-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqLGdZRFXni0Y5Loij3FVfw8RzaizNaRA+_hccXz0opkKw@mail.gmail.com>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org> <20140823161456.GA2758@localhost> <CAL_JsqLGdZRFXni0Y5Loij3FVfw8RzaizNaRA+_hccXz0opkKw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fnt7z7cDY94EwYpLt3sZPm7SRGzXbeXCjniWA+2MT7K
 FtwUg8CFLix7kWsDtMEHqZ6OgRPQYX1N/gVRNa/77IwwZB/FY0
 H5uhakb/0TBty54gzW0IetgBACZno2g12jnbCsxUhSm9r1mDlo
 ViuKyPxHCcFshxsj0Jo4SFE550NYSE/qsatJv0B+CVzkAjuYOg
 ml2/XahyPt/qs+PUs85Vu2T+3KILgCPqg9HB+Sy4FgyXYKGrZD
 UBUSIrbPIX2jHwGJU7sn8jyNA3fAXcsOmPu4aqCf37jHynlqnF
 T+CO6VUBHtlsfHaKmNmonQYgUetinja9LbwjJOKcQWEqCIyQv/
 KIlw420VLkZ5ReHUZLso=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 August 2014 18:43:35 Rob Herring wrote:
> On Sat, Aug 23, 2014 at 11:14 AM, Olof Johansson <olof@lixom.net> wrote:
> > On Sat, Aug 23, 2014 at 03:56:42PM +0200, Arnd Bergmann wrote:
> >>
> >> Another argument is that we plan to actually move all the dts files out of
> >> the kernel into a separate project in the future. We really don't want to
> >> have the churn of moving all the files now when they get deleted in one
> >> of the next merge windows.
> >
> > To be honest, I don't see that happening within the forseeable
> > future. Some of us maintainers like talking about this, but everyone who
> > actually develops have nightmares about this scenario. Nobody knows how
> > it'll be done without causing some real serious impact on productivity.
> >
> >> I don't know if we talked about whether that move should be done for
> >> all architectures at the same time. If that is the plan, I think it
> >> would be best to not move the MIPS files at all but also wait until
> >> they can get removed from the kernel tree.
> >
> > If MIPS can restructure now before things start growing, then I'd really
> > recommend that they do so and not hold off waiting on some event that
> > might never happen. 
> 
> Yes, I agree on both points.
> 

Ok, fair enough.

	Arnd
