Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaKZRts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:49:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:58782 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaKZRtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:49:46 -0500
Message-ID: <547612B4.8000909@kernel.org>
Date: Thu, 27 Nov 2014 02:49:40 +0900
From: Kukjin Kim <kgene@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, jh80.chung@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, yj44.cho@samsung.com, geunsik.lim@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 0/3] ARM: dts: add the support of Exynos3250-based Monk
 board
References: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/14 19:57, Chanwoo Choi wrote:
> This patchset adds the support of Exynos3250-based Monk board and Exynos-based
> boards compatible string and description to remove build warning. Also, this
> patchset includes a patch which remove unused dt node for command line in
> Exynos3250-based Rinato dts file.
> 
> Changes from v2:
> - Include new patches by Chanwoo Choi with following patch[1]
>   [1] http://www.spinics.net/lists/arm-kernel/msg368443.html
> 
> Changes from v1:
> - Fix minor issue
> 
> Chanwoo Choi (2):
>   ARM: exynos: Add Exynos-based boards compatible string and description
>   ARM: dts: Remove unused command line from Exynos3250-based Rinato board
> 
> Youngjun Cho (1):
>   ARM: dts: add board dts file for Exynos3250-based Monk board
> 
>  .../devicetree/bindings/arm/samsung-boards.txt     |  19 +-
>  arch/arm/boot/dts/Makefile                         |   3 +-
>  arch/arm/boot/dts/exynos3250-monk.dts              | 579 +++++++++++++++++++++
>  arch/arm/boot/dts/exynos3250-rinato.dts            |   4 -
>  4 files changed, 595 insertions(+), 10 deletions(-)
>  create mode 100644 arch/arm/boot/dts/exynos3250-monk.dts
> 
Applied, thanks.

- Kukjin
