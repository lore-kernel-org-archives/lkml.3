Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3BEQWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:22:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37325 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab3BEQWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:22:09 -0500
Date: Tue, 5 Feb 2013 17:22:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] drm/nouveau: always select ACPI_VIDEO if ACPI is
 enabled.
Message-ID: <20130205162206.GJ4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
References: <20130204152344.GG13909@pd.tnic>
 <510FD6A2.80101@canonical.com>
 <20130205145232.GI4827@pd.tnic>
 <5111277B.5020607@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5111277B.5020607@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:38:35PM +0100, Maarten Lankhorst wrote:
> Argh, next attempt, based on i915's Kconfig.
> 
> It seems that not only I have to select ACPI_VIDEO, I also have to select all the dependencies.
> Is this a Kconfig bug or working as intended? i915 seems to have a workaround, so I copied it from
> there. Except it's currently missing select THERMAL, so I guess it didn't get updated when that got
> added.
> 
> ---->8
> Having nouveau builtin would still allow ACPI_VIDEO to be used as external module
> if some of the deps for acpi_video have not been met, which would result in a linking
> failure. Solve this by selecting all dependencies as well.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Yep, this takes care of all deps,

Tested-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
