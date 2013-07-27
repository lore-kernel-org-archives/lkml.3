Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3G0Fea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 01:34:30 -0400
Received: from purkki.adurom.net ([80.68.90.206]:46108 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab3G0Fe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 01:34:29 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?utf-8?Q?J=C3=B6r?= =?utf-8?Q?g?= Otte <jrg.otte@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	<9012759.Alzqtdvh5b@vostro.rjw.lan>
	<2218913.HKGjJcYT1G@vostro.rjw.lan>
Date: Sat, 27 Jul 2013 08:34:13 +0300
In-Reply-To: <2218913.HKGjJcYT1G@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Thu, 25 Jul 2013 15:00:26 +0200")
Message-ID: <871u6ky3ai.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
> fixes the backlight for you.

I did three suspend-resume cycles and didn't notice anything wrong so
this patch fixes the issue for me. I'll continue testing and will report
if I spot any problems.

Tested-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
