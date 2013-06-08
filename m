Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3FHJEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:04:45 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47423 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3FHJEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:04:42 -0400
Date: Sat, 8 Jun 2013 17:04:33 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't
 have EC controllable LEDs
Message-ID: <20130608090433.GB7334@adam-laptop>
Mail-Followup-To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
 <1370611358.6315.48.camel@x230.lan>
 <20130607150651.GA2227@adam-laptop>
 <1370636175.13515.140661241274985.19126A97@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370636175.13515.140661241274985.19126A97@webmail.messagingengine.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:16:15PM -0300, Henrique de Moraes Holschuh wrote:
> Can you get me the ACPI interface documentation?  It should be simple
> to get it, but I haven't emailed the Lenovo BIOS engineers for some
> time.
> 
> Basically, create a new LED method in thinkpad-acpi, lock it down to
> vendor lenovo, detect the new interfaces, and only check the
> two-argument LED one if the newer ones aren't found.
> 
> Not supporting the old /proc interface on new thinkpads is fine.

Thanks, I will request the documentation from Lenovo again.

Please apply "[PATCH 1/3 v3] thinkpad_acpi: return -NODEV while operating uninitialized LEDs" and
"[PATCH 2/3] thinkpad_acpi: add the ability setting TPACPI_LED_NONE by quirk", but
hold "[PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't have EC controllable LEDs",
I will drop [PATCH 3/3] to discussion again when I got the documentation.

-- 
Regards,
Adam Lee
Hardware Enablement
