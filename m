Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3GXFKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 01:10:30 -0400
Received: from purkki.adurom.net ([80.68.90.206]:36360 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3GXFK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 01:10:29 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>
Subject: Re: Linux 3.11-rc2
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<5728692.GlhGgHY92H@vostro.rjw.lan> <3298830.Snx2ykMFY6@merkaba>
	<8019054.MeLu41uqLm@vostro.rjw.lan>
Date: Wed, 24 Jul 2013 08:10:14 +0300
In-Reply-To: <8019054.MeLu41uqLm@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Mon, 22 Jul 2013 15:37:42 +0200")
Message-ID: <8761w0y24p.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Well, please try to revert commits efaa14c and 8c5bd7a (in this order) and see
> if that helps.

On 3.11-rc2-wl (from wireless-testing.git) my Thinkpad X230 display went
really dark every time during resume and I had to blindly write to sysfs
to be able to see anything. With 3.10-wl I didn't see this. Reverting
the commits above fixed the issue for me.

I'm using Ubuntu 12.04 64 bit. More info about my laptop:

  thinkpad_acpi: ThinkPad ACPI Extras v0.24
  thinkpad_acpi: http://ibm-acpi.sf.net/
  thinkpad_acpi: ThinkPad BIOS G2ET82WW (2.02 ), EC unknown
  thinkpad_acpi: Lenovo ThinkPad X230, model 2324JB2
  thinkpad_acpi: detected a 8-level brightness capable ThinkPad
  thinkpad_acpi: radio switch found; radios are enabled
  thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness
  control, supported by the ACPI video driver
  thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
  thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
  thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
  thinkpad_acpi: Standard ACPI backlight interface available, not
  loading native one
  thinkpad_acpi: Console audio control enabled, mode: monitor (read
  only)
  input: ThinkPad Extra Buttons as
  /devices/platform/thinkpad_acpi/input/input5

-- 
Kalle Valo
