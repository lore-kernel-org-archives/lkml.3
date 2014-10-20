Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaJTNtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:49:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63362 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaJTNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:49:03 -0400
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
Subject: Re: [PATCH v2 1/5] Documentation: DT: Renamed of-serial.txt to 8250.txt
Date: Mon, 20 Oct 2014 15:47:42 +0200
Message-ID: <1938561.uq5BpWofVY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413539665-11484-2-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1413539665-11484-2-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0xgIRRc+rdrU1UXkirX3u8Js3HETQjr/tOH3m/jf+QC
 uMLXgCn5x9hxY47DHYWRXHYkPUgSBdI5P7O4NQuhr/IvMVoQWb
 lFnlzK01rerlIdzrwnKEqA0D6Ag4Wm+EmhqkolE7I5gqeMuQdS
 xRoJ60V0/wPgtKX8sqwC5tz9hwSOHzPOCJFJjRs33ZVQeLUUzN
 sGYioMD93rC/Dx98gN1dTgJoqCIYrLcg05T2zd+WjVUPu2cfj0
 KKcSQkiocQZ9q6aTILTHnUvFkdA/LOFztRABHvdE01ICD6cGfk
 GGMhSQMexc3rCTc1eMFvbNRx5Kfztfe+83TqMbVltHlcnaveqC
 yAFotqzaP0SkAtmONBWw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2014 17:54:21 Chunyan Zhang wrote:
> The file of-serial.txt was only for 8250 compatible UART implementations,
> so renamed it to 8250.txt to avoid confusing other persons.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> ---
>  Documentation/devicetree/bindings/serial/8250.txt  |   50 ++++++++++++++++++++
>  .../devicetree/bindings/serial/of-serial.txt       |   50 --------------------
>  2 files changed, 50 insertions(+), 50 deletions(-)
> 

Patch looks good, but please use 'git format-patch -M' when generating it,
to avoid having the whole add/remove in the patch, for easier review.

	Arnd
