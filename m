Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3CFAEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:04:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49651 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3CFAEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:04:31 -0500
Date: Wed, 6 Mar 2013 01:04:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lucas Stach <dev@lynxeye.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: nouveau lockdep splat
Message-ID: <20130306000429.GA30189@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lucas Stach <dev@lynxeye.de>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>
References: <20130304211608.GD22274@pd.tnic>
 <1362501052.1933.2.camel@antimon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362501052.1933.2.camel@antimon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 05:30:52PM +0100, Lucas Stach wrote:
> Dropping Tegra ML, it's not the place where Nouveau mails should go.

$ ./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau/nv50_display.c
...
linux-tegra@vger.kernel.org (open list:TEGRA SUPPORT)

Maybe get_maintainer.pl patterns need correction...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
