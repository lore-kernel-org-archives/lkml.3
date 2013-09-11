Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3IKJLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:11:22 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:53787 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3IKJLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:11:20 -0400
Message-ID: <1378890565.4179.2.camel@oban>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Vetter <daniel@ffwll.ch>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Date: Wed, 11 Sep 2013 11:09:25 +0200
In-Reply-To: <1378889140.945.0.camel@x230.lan>
References: <522D88C3.7000808@intel.com> <5155010.Y1gov7SKhP@vostro.rjw.lan>
	 <87eh8wail7.fsf@intel.com> <1889567.vxI8heiC3B@vostro.rjw.lan>
	 <20130911013206.GA556@mint-spring.sh.intel.com> <87hadrycf4.fsf@intel.com>
	 <1378889140.945.0.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mer., 2013-09-11 at 08:45 +0000, Matthew Garrett wrote:
> On Wed, 2013-09-11 at 11:45 +0300, Jani Nikula wrote:
> 
> > Before plunging forward, have you observed any difference between the
> > boot modes? We have reports [1] that the backlight behaviour is
> > different with UEFI vs. UEFI+CSM or legacy boot. So I'm wondering if the
> > acpi_gbl_osi_data >= ACPI_OSI_WIN_8 check in patch 2/2 is the whole
> > story.
> > 
> > Further, if we tell the BIOS we're Windows 8 to use the tested BIOS code
> > paths, what guarantees do we have of UEFI+CSM or legacy boots working?
> 
> We have no evidence of Windows behaving differently based on the exposed
> firmware type.
> 
I do have an X230 which boots fine using pure UEFI or UEFI+CSM (and I
guess I can try booting it with a grml for pure legacy), so I can do
tests if needed.

Regards,
-- 
Yves-Alexis

