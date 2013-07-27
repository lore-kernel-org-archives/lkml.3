Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3G0MId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 08:08:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43222 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab3G0MIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 08:08:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kalle Valo <kvalo@adurom.com>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
Date: Sat, 27 Jul 2013 14:18:34 +0200
Message-ID: <2993276.3bLcHY9ihM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <871u6ky3ai.fsf@purkki.adurom.net>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <2218913.HKGjJcYT1G@vostro.rjw.lan> <871u6ky3ai.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 27, 2013 08:34:13 AM Kalle Valo wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
> > fixes the backlight for you.
> 
> I did three suspend-resume cycles and didn't notice anything wrong so
> this patch fixes the issue for me. I'll continue testing and will report
> if I spot any problems.
> 
> Tested-by: Kalle Valo <kvalo@adurom.com>

Thanks a lot for the confirmation, this already is in the Linus' tree.

Rafael

