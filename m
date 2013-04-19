Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3DSKKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:10:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61708 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab3DSKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:10:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/2] dma: of: Fix of_node reference leak
Date: Fri, 19 Apr 2013 12:10:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
References: <1366364534-3298-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1366364534-3298-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191210.27151.arnd@arndb.de>
X-Provags-ID: V02:K0:3tp9MMRadmbjzGnZ6yTDY4RKeSDr4eVgPUCEqlzz5Gm
 J+2Y8toDdAem3Wbhp2fQuyY4e4NP4swObc5WtFfJ2UYlpIJTjG
 O9/wU8/NkQt+rUgvz7y1mXvrP3Dv6Pp9VD9NZ0tsCVYN7Ek5u5
 gAtPXWU1FrdBRIEMynA7ruIp+gN02Hr7T2AqAPL99FKAIp/pMK
 3Xb8avISyfvdAM3syqRrcXEjPTmHtl05XE0dX9rNTbJtNdT9h9
 PA14WWYoSPayEgCa6v0tbDL6HmHDxI/0E9AuaJ647J/HbarzVT
 omasuEpqzFgdKL3JQY1yv9xuL+zFMw2aRgUZeiVamJHAuJ5l7z
 PIRGjihrmA63DyM55i2I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Lars-Peter Clausen wrote:
> of_dma_request_slave_channel() currently does not drop the reference to the
> dma_spec of_node if no DMA controller matching the of_node could be found. This
> patch fixes it by always calling of_node_put().
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
