Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3AUAB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:01:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3AUABY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:01:24 -0500
Date: Mon, 21 Jan 2013 01:04:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?utf-8?B?QW5kcsOp?= Przywara <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/6] acpi-cpufreq and powernow-k8 fixes
Message-ID: <20130121000402.GA19343@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	=?utf-8?B?QW5kcsOp?= Przywara <andre@andrep.de>,
	Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
	cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
 <1838903.lYvY4Nk4I1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1838903.lYvY4Nk4I1@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 03:18:11PM +0100, Rafael J. Wysocki wrote:
> Well, it all looks reasonable to me.
>
> I suppose you'd like it to go into v3.8 plus v3.7-stable, right?

Well, sort of.

Patch 0001 which you've already taken and tagged for 3.7-stable and is
on its way to 3.8 is fine since it fixes a bug.

The rest are, IMHO, more or less annoyances fixes which could easily
wait for 3.9 and maybe be backported if there really is an issue. Also,
they'd see a lot more testing this way. Because in at least 99% of the
cases, acpi-cpufreq and powernow-k8 are modules and the handoff works
there.

This is at least how I see it, you tell me whether it makes sense or
not.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
