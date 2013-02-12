Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3BLW0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:26:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3BLW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:26:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
Date: Tue, 12 Feb 2013 22:25:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5119849B.1070300@wwwdotorg.org> <201302121732.14960.arnd@arndb.de> <511AAB81.4000306@wwwdotorg.org>
In-Reply-To: <511AAB81.4000306@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302122225.58322.arnd@arndb.de>
X-Provags-ID: V02:K0:MVegPsl0b+I8K4k/xKUMWqseszNCb5hmWImK9NOWa7j
 I427P9thTUQT31s0FKY+2nWOULLCfMIolRjvPyms7okLvGowv/
 xpDFPQGRL8WLqKe2+v8rhcqUl9zsZItBXHmqJFOKzc4Z24QhAz
 5FhA48ozRGhBokLb90UGvqYkat5YScEVXsHMWFX4nbiEnlvB4O
 LUSrMzR1ZemwGbjys0TPP+Cq0NFtS4SVFeOYUSuL9+cGrv+s4Y
 ICBU0GextaAC28rNehISOmxIRpD/XDyUGugkIn6UGyV9GkKU+2
 3Aak9X4uROHwC2hLSa+8PUZfaw5qKAU08fJnlkFKxCPAIMoR1W
 3z6+pUEi4mHgbCmVYm2Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Stephen Warren wrote:
> I believe U-Boot enabled -ffunction-sections -fdata-sections or similar
> (recently?) to get this kind of behaviour. I wonder why the kernel
> didn't need that. Perhaps -O2 is more aggressive (within a file at
> least) than I thought.

-ffunction-sections works across files, while the trick I described
only works on file static symbols. David Woodhouse at some point
had a working kernel build with -ffunction-sections but for some
reason that never got merged.

	Arnd
