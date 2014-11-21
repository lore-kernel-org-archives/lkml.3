Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaKUUSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:18:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40855 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaKUUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:18:49 -0500
Date: Fri, 21 Nov 2014 21:18:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Ben Goz <ben.goz@amd.com>, Jay Cornwall <jay.cornwall@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: Re: [PATCH v5 08/24] amdkfd: Add amdkfd skeleton driver
Message-ID: <20141121201846.GB5473@pd.tnic>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
 <1415471865-1893-9-git-send-email-oded.gabbay@amd.com>
 <1416565445.6958.3.camel@x220>
 <546F93D5.8030704@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <546F93D5.8030704@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:34:45PM +0200, Oded Gabbay wrote:
> The DRM_AMDGPU symbol belongs to AMD's new Linux kernel graphic
> driver, called amdgpu. That driver is not yet upstreamed, so its
> symbol is not present in any Kconfig file. However, internally we work
> with that driver so that's why it appears in my patch.
>
> I can remove it if it violates some rule.

Yes it does: no out-of-tree symbols. Please remove it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
