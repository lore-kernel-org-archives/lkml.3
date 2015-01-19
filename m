Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbbASNmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:42:02 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56367 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbASNmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:42:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rameshwar Prasad Sahu <rsahu@apm.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ddutile@redhat.com,
        jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
Subject: Re: [PATCH v3 1/3] dmaengine: Add support for APM X-Gene SoC DMA engine driver
Date: Mon, 19 Jan 2015 14:41:45 +0100
Message-ID: <1648508.n83Xs10nv8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421671269-19441-2-git-send-email-rsahu@apm.com>
References: <1421671269-19441-1-git-send-email-rsahu@apm.com> <1421671269-19441-2-git-send-email-rsahu@apm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:vggg3C6+p4kBvhxrVPSqquy8Pkmxn+Vfp1jSlZFbdlFpnCbCDCE
 eHq5tCbKG1QGojcfPqdifplUdmIiSPvDbGsoxBUycc9rxdx//VFqMng6YIsF5KfbeFVporj
 XoiZFZlQt+Gv/tMQmB7+bLt3wtAY5kj5O9vhT5xPNSednEG6vlc+b1mQKsfBjlG9d9k4Wti
 VwQ8qA7INIKt2eqa1kUdg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 18:11:07 Rameshwar Prasad Sahu wrote:
> This patch implements the APM X-Gene SoC DMA engine driver. The APM X-Gene
> SoC DMA engine consists of 4 DMA channels for performing DMA operations.
> These DMA operations include memory copy and scatter gathering offload.
> 
> Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
> Signed-off-by: Loc Ho <lho@apm.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
