Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaJTNum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:50:42 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50235 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaJTNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:50:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk,
        jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        artagnon@gmail.com, rrichter@cavium.com, robh+dt@kernel.org,
        will.deacon@arm.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, sprdlinux@freelists.org
Subject: Re: [PATCH v2 2/5] Documentation: DT: Add bindings for Spreadtrum Sharkl Platform
Date: Mon, 20 Oct 2014 15:48:46 +0200
Message-ID: <9863286.bSvbeP9S6p@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413539665-11484-3-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1413539665-11484-3-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:riRGPxHOJzPmPnbjOt7ddqdtztcd0UMrf4CWyWd5a/F
 pgU6Ibf8Qg+qvMqVQ/y6Y8zMtoPuceeBybI1voQM06KxCRHdmY
 1edOLXlYXB/zE5yr2cMRi5/YT9hoLie6YW1Ph5hYD2+1qcOFsI
 PBPtVaezjSs61SSCSafStme0sP+4Jl1myD9NJ9idaHj27ew48v
 3Bk1yb9MyMkQgED9qoCejPeTWjlIM9+oUULItr1qO4NtQzgk8Y
 btfNXh5MK+LWWq22P4NHBU7rH+zwZYVdARj6CkP8saswSpq00X
 I/TSdkmYy8HeZFZar1Vs/2EgSw8WgV8J02so+fFZeUw757Hfqb
 1QcrvtTHl+tP5R2+qwWg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2014 17:54:22 Chunyan Zhang wrote:
> Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
> Adds the devicetree binding documentation for Spreadtrum's serial
> and Sharkl3 SoC based on the Sharkl Platform which is the 64-bit
> SoC Platform of Spreadtrum.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
