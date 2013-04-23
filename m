Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3DWTbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:31:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3DWTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:31:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 05/21] ARM: OMAP2+: add dependencies on ARCH_MULTI_V6/V7
Date: Tue, 23 Apr 2013 21:31:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-6-git-send-email-arnd@arndb.de> <20130423180146.GI10155@atomide.com>
In-Reply-To: <20130423180146.GI10155@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232131.07512.arnd@arndb.de>
X-Provags-ID: V02:K0:V5S+15PqiQAwad6raDy4DOtRqIZSW+AYwLzdoCGIpJl
 g9ai/b1y+TjJ21mvOZeVmD6Jp7taTwFAbm6pntlIM2xjxfU/d0
 3Lkxv51PA81fz0eUGbgq9RNBKCo8XdD7lV5ntU9Sqr6WOssj6k
 Z88NSlU6B3aGbrrB7f6/yqSBEjoaKTNWI5ED+BnYSbx4qqTSFx
 EnpVXehNlAcva9FVVnF/WGRs3S/XwxYGzZXmH5PuwIrvIyVJBx
 U7NcrO1qpg00ZDqe10u0eRwj7WG3AtSNEd/h7bCUBH2zWlURja
 DwA65a3vVXE2Tcaa2oCg02L4jJ+swsicWUG9I0jdwVESZfVbaz
 cSV0t8ddNIETJa/u1ZxE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [130423 09:36]:
> > CONFIG_ARCH_OMAP2PLUS depends on (ARCH_MULTI_V6 || ARCH_MULTI_V7) as of
> > a0694861 "ARM: OMAP2+: Enable ARCH_MULTIPLATFORM support", but the
> > individual OMAP2/3/4/5 and AM33XX platforms can all be selected independent
> > of what we are building for, which is a bug and prevents us from easily
> > building e.g. an ARMv7-only defconfig.
> > 
> > This makes ARCH_OMAP2 depend on ARCH_MULTI_V6 and the others depend on
> > ARCH_MULTI_V7, to ensure we really only build the platforms for the
> > CPUs we have enabled in the global multiplatform configuration step.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 
Thanks, I've now applied it to the next/fixes-non-critical branch.

	Arnd
