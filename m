Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaENMqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:46:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62058 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaENMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:46:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org, t.figa@samsung.com,
        pullip.cho@samsung.com, shaik.samsung@gmail.com
Subject: Re: [PATCH] documentation/iommu: Add note on existing DT binding status
Date: Wed, 14 May 2014 14:46:07 +0200
Message-ID: <4285609.T2z8nUPpCQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400046813-15248-1-git-send-email-shaik.ameer@samsung.com>
References: <1400046813-15248-1-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jITjRxQbKQzL2Cxg1UCgWk5AFKpQQiAZ6WXvcrPdXxQ
 j6X/xtp7VE5TyCZXkQbZbzlgB9BK3KNsdK2VbFfWpImEmlYEpp
 8ImG4Kf6L5w/rztAUPDBovQet9+EZJ5XOG218LQ3cS+/bHVU4Q
 UMqlVPlOYYO4tqw+ju4u56L/pKiZQQW47brqH5s2iKp0wkLyKv
 qzo640yvXNe59puilzH5k07aWlVqdNj/kRGgrfv4CxAgbcI3lO
 4e4i39FBr5Hp3DZ84o0qzPH98ZfXE23EczbiIK6b2OqcB2bAw+
 BKQjvrpseSK81FyfFxr9os0ylS8XAyl3MV/XJVqnJtL9WlgCOh
 171aw2I3tPGc95Kl8nXA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 11:23:33 Shaik Ameer Basha wrote:
> The current dt binding for Exynos System MMU can be changed, if found
> incompatible with the support for "Generic IOMMU Binding".
> This patch adds a note to the binding documentation stating the same.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
