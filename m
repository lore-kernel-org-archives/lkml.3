Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3BKUFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:05:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3BKUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:05:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v2 1/3] mfd: syscon: Removed support for unloading
Date: Mon, 11 Feb 2013 20:05:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1360608173-12907-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302112005.35034.arnd@arndb.de>
X-Provags-ID: V02:K0:4dEjkb1r+pIKaRi2D9jwvXjp/Wlcn8EzzAckMbvX2Vh
 ZNqAS8wBoOfRfmOvOMDrEr19oytMGkbWgM8XgnANb1mT3chJ5z
 6PaSSD2PhP8q127FnEhtiTxY7o4PkV8FbUXpTdZDgNBDSEFnUn
 0wDaPARa4mI7DgfVE5sxwUu0dPSxSP39iWgcVk9iA/Tt6WHX0Y
 8nOd3bmO8io9dmvYmu/zE0acpTE7vwWlloBiiiXVTNsGJTPcxI
 ECGYT5PUE028t241pOQBPv6TFh+xy0SU6i08nnrkFjv0BPWA5I
 Ti9XJAeSh59gvwb/3lfrcqRpKNCv5mg0PhO3wBEie3mZ3b05EV
 Q3IywtLXIZkzmg+C6vjo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013, Alexander Shiyan wrote:
> The driver can be used in various subsystems and therefore should not
> be unloaded when it is defined in the kernel configuration, so remove
> support for unloading it.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Can you describe a scenario where that would happen? Normally the
module should stay pinned as long as any other module refers
to its exported symbols.

	Arnd
