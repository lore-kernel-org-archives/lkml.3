Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3AVVxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:53:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3AVVxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:53:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
Date: Tue, 22 Jan 2013 21:53:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com>
In-Reply-To: <1358891160-9534-1-git-send-email-robdclark@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301222153.19580.arnd@arndb.de>
X-Provags-ID: V02:K0:rmNgwD5Nlsun1uveciiTvOdp53fV57tsCfemiJQ+2X4
 zfMKuwdDsmdgCtSK32c+G9XE2SKDBGBwZOoq9H96zAFoKnnU5b
 HbOnXwITwbtU9LFJ0o3bz0oemEAwGOiv5+gLcWqO7TBY3f174p
 0qSVGxyASH9Ajtbk5OrWP6Pw8EqmvCujm8ZGQvrR38ffIRS883
 7WsvjpEQo1FB5KzPRZtWiCv8+ZG90lP/gWOecyZ0xQyVLxDwjn
 7KsAq1DpJoMRt99EfAnSrDCmlXJD8nb5GBX7CJfbB+/xrpc8UQ
 JP0DC4cb3VHusoSGLaf7xRSNLuKMQ6HII1rg7EEuVitZU+9LEb
 qYk8xz+qpI8XWGE5qb+M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Rob Clark wrote:
> At least core omapdss does not have any build dependencies on
> ARCH_OMAP2PLUS, and adding this dependency in the Kconfig breaks omapdrm
> for ARCH_MULTIPLATFORM builds.
> 
> Signed-off-by: Rob Clark <robdclark@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
