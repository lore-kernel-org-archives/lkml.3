Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3FOSoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 14:44:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40176 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3FOSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 14:44:15 -0400
Date: Sat, 15 Jun 2013 19:44:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Aaron Lu <aaron.lu@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
Message-ID: <20130615184405.GA11196@srcf.ucam.org>
References: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
 <51BABC6F.3050201@intel.com>
 <1371230988.2490.2.camel@x230>
 <51BBC2E1.9040401@intel.com>
 <1371260284.523.2.camel@x230>
 <51BBEA32.1040002@intel.com>
 <20130615041945.GA4756@srcf.ucam.org>
 <51BC5E1B.2020400@intel.com>
 <20130615151628.GA9868@srcf.ucam.org>
 <20130615182942.GA6424@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615182942.GA6424@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 08:29:42PM +0200, Daniel Vetter wrote:

> Aside at the end: If the gnome tool indeed has its own backlight code and
> doesn't just use that as a fallback if the xrandr backligh property isn't
> available, then that's just a serious bug in gnome and should be fixed
> asap. But imo that's not something we should try to (nor do I see any way
> how to) work around in the kernel.

It's only used if there's no backlight property on the display.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
