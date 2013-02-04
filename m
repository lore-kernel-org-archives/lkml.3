Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3BDPXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:23:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49411 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab3BDPXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:23:54 -0500
Date: Mon, 4 Feb 2013 16:23:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: dri-devel@lists.freedesktop.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: drivers/gpu/drm/nouveau/nouveau_acpi.c:420: undefined reference to
 `acpi_video_get_edid'
Message-ID: <20130204152344.GG13909@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm guessing someone has already triggered this on latest Linus' tree
and has a fix?

drivers/built-in.o: In function `nouveau_acpi_edid':
/w/kernel/linux/drivers/gpu/drm/nouveau/nouveau_acpi.c:420: undefined reference to `acpi_video_get_edid'
make: *** [vmlinux] Error 1

Btw, I got CONFIG_ACPI_VIDEO=m while CONFIG_DRM_NOUVEAU=y and this is
probably the reason for the vmlinux link error.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
