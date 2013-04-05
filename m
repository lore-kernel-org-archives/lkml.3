Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162791Ab3DEUmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:42:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63541 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162655Ab3DEUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:42:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 1/9] arm: mvebu: Limit the DMA zone when LPAE is selected
Date: Fri, 5 Apr 2013 22:41:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <1365193444-13441-2-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1365193444-13441-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304052241.14865.arnd@arndb.de>
X-Provags-ID: V02:K0:f3UZ0tGhitqCXNPPs+WjZrk4BsGsQ7v7xDraWcjf9lR
 jEW4mtrmIMIPQ0q/1myMo4M9QQxLybxhzdG7W7nrLppNCVec3a
 z0EXZ1VdfUMehHlbWe+3nZ5RaZJSPU3cRl87Ga7XwHseKOpYKr
 o72sdKPABSD/ITVkWsownGK9Tly7OhDDkGV3QvTRZHLc96ch7M
 QLWWG55neEhAWebBiQVT7m5I/xhvbskFpgmiuenbvikAGxmqQA
 dUqaVQnviQNq/BR+1rZSQJDH5bwVErnWwHGKaW8yWi+79ftgB0
 VArfiQpqFbDtYaswr6tH4gwMzS9I7z0ktoD0f1zjIo4XRSKNuh
 05tBQxWs80zaJUYV1/ag=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Gregory CLEMENT wrote:
> When LPAE is activated on Armada XP, all registers and IOs are still
> 32bit, the 40bit extension is on the CPU to DRAM path (windows) only.
> That means that all the DMA transfer are restricted to the low 32 bits
> address space. This is limitation is achieved by selecting ZONE_DMA.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Shouldn't that be ZONE_DMA32?

	Arnd
