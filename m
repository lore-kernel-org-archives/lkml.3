Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3CFTxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:53:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48070 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab3CFTxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:53:47 -0500
Date: Wed, 6 Mar 2013 20:53:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas Stach <dev@lynxeye.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: nouveau lockdep splat
Message-ID: <20130306195342.GF30673@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lucas Stach <dev@lynxeye.de>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>
References: <20130304211608.GD22274@pd.tnic>
 <1362501052.1933.2.camel@antimon>
 <20130306000429.GA30189@pd.tnic>
 <20130306191418.GA3400@joi.lan>
 <513799A5.3010609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <513799A5.3010609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 12:31:49PM -0700, Stephen Warren wrote:
> get_maintainer.pl could always look at file contents IIRC. The change
> was that I added keyword "tegra" to the Tegra section that now matches
> this file's contents.
> 
> ./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau
> 
> ... might be a better invocation, although perhaps I should add an
> explicit exclusion for "nouveau" to the Tegra section in MAINTAINERS.

No, you should add a pattern which matches only tegra. If there's no
such pattern, you should simply drop the "K:" thing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
