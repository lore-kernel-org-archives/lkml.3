Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445AbaDJJpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:45:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:63802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935362AbaDJJpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:45:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 02/27] ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250
Date: Thu, 10 Apr 2014 11:45:07 +0200
Message-ID: <4172202.teSeEmypAU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397122124-15690-3-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com> <1397122124-15690-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:m+w1EuYrIAlsnN/SiMUzUtcil7R/DgVQVvhmCZT3XAB
 vFXmo0NIzqj4th/Td7JN4cGY7/eROCcvg/9H2zPhog0mivbunQ
 EsMwfUIe6atbH37ZyAJMZuzq+0M+ejgQB1KuydumJWdwiNnYE/
 VJQzWIAdyWnZcA6YRFMzG9tXGEHQFlQaaS5auIwhh9593NAcBx
 jYq3Lf11s2OSM14S+a9YFUTgFr0NGeim22aHCfIjjdFRd/2mWu
 m2pbvEggrLEvQdpogaJZl7CXgozvSZQ7fz/X75YBu9K5EsZrzO
 xB+YOgMyNNE+q2CyaH5cFu5kJIoME+Hqzu5ycqzHIRVsy2PRe0
 05kYN20LfrA7R4AEYknM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 18:28:19 Chanwoo Choi wrote:
> 
> The non-secure SYSRAM is used for secondary CPU bring-up. This patch add
> IO mapping for non-scure SYSRAM.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I really don't want to see any further static mappings here. We had the
same discussion for the previous Exynos chip that was submitted, so please
describe the SYSRAM in DT, and start thinking about the other static mappings
that can be removed.

	Arnd
