Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3AUAHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:07:21 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47891 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3AUAHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:07:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: =?ISO-8859-1?Q?Andr=E9?= Przywara <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/6] acpi-cpufreq and powernow-k8 fixes
Date: Mon, 21 Jan 2013 01:13:18 +0100
Message-ID: <7556596.NKy4LTm5hO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130121000402.GA19343@pd.tnic>
References: <1358677470-17394-1-git-send-email-bp@alien8.de> <1838903.lYvY4Nk4I1@vostro.rjw.lan> <20130121000402.GA19343@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 01:04:02 AM Borislav Petkov wrote:
> On Sun, Jan 20, 2013 at 03:18:11PM +0100, Rafael J. Wysocki wrote:
> > Well, it all looks reasonable to me.
> >
> > I suppose you'd like it to go into v3.8 plus v3.7-stable, right?
> 
> Well, sort of.
> 
> Patch 0001 which you've already taken and tagged for 3.7-stable and is
> on its way to 3.8 is fine since it fixes a bug.
> 
> The rest are, IMHO, more or less annoyances fixes which could easily
> wait for 3.9 and maybe be backported if there really is an issue. Also,
> they'd see a lot more testing this way. Because in at least 99% of the
> cases, acpi-cpufreq and powernow-k8 are modules and the handoff works
> there.
> 
> This is at least how I see it, you tell me whether it makes sense or
> not.

Yes, it does.

I will take [2-6/6] for v3.9, then, if there are no objections.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
