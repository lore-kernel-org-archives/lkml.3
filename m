Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3GFOJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 10:09:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42521 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab3GFOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 10:09:05 -0400
X-Sasl-enc: wDr3U8LUtV2+Zdp0QY5VktA7QiUnpxY9QXzszOPp74L0 1373119744
Date: Sat, 6 Jul 2013 11:09:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, rui.zhang@intel.com,
        lenb@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH 2/3] ACPI: Remove old /proc/acpi/event interface
Message-ID: <20130706140900.GB16737@khazad-dum.debian.net>
References: <1372855719-34315-1-git-send-email-trenn@suse.de>
 <1372855719-34315-3-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372855719-34315-3-git-send-email-trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jul 2013, Thomas Renninger wrote:
> It is quite some time that this one is deprecated.
> Get rid of it.
> 
> If there should really some important user be overseen it could get reverted
> and worked on the userspace program first. But it is time to do something to
> get rid of this old stuff...
> 
> CC: rui.zhang@intel.com
> CC: lenb@kernel.org
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Matthew Garrett <matthew.garrett@nebula.com>
> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

For the thinkpad-acpi hunks:
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  Documentation/laptops/asus-laptop.txt   |    8 +-
>  Documentation/laptops/sony-laptop.txt   |    8 +-
>  Documentation/power/video_extension.txt |   15 -----
>  drivers/acpi/Kconfig                    |   18 -----
>  drivers/acpi/ac.c                       |    1 -
>  drivers/acpi/acpi_pad.c                 |    1 -
>  drivers/acpi/battery.c                  |    2 -
>  drivers/acpi/bus.c                      |   98 ----------------------------
>  drivers/acpi/button.c                   |    2 -
>  drivers/acpi/event.c                    |  106 -------------------------------
>  drivers/acpi/processor_driver.c         |    4 -
>  drivers/acpi/sbs.c                      |   15 +----
>  drivers/acpi/thermal.c                  |    3 -
>  drivers/acpi/video.c                    |   10 ---
>  drivers/platform/x86/asus-laptop.c      |    1 -
>  drivers/platform/x86/eeepc-laptop.c     |    1 -
>  drivers/platform/x86/fujitsu-laptop.c   |    4 -
>  drivers/platform/x86/panasonic-laptop.c |    3 -
>  drivers/platform/x86/sony-laptop.c      |    4 -
>  drivers/platform/x86/thinkpad_acpi.c    |   11 ---
>  include/acpi/acpi_bus.h                 |    9 ---
>  21 files changed, 10 insertions(+), 314 deletions(-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
