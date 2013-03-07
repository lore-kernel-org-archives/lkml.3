Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab3CGLYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:24:36 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:59340 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278Ab3CGLYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:24:35 -0500
Message-ID: <1362655472.5994.2.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: EXYNOS: remove EXYNOS_DEV_SYSMMU entirely
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 12:24:32 +0100
In-Reply-To: <014f01ce1ad0$e4432b10$acc98130$%kim@samsung.com>
References: <1362509466.16460.108.camel@x61.thuisdomein>
	 <014f01ce1ad0$e4432b10$acc98130$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2013 11:24:33.0123 (UTC) FILETIME=[5782F330:01CE1B26]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 10:12 +0900, Kukjin Kim wrote:
> Actually, to update iommu for exynos is on-going. And as I know, it
> will be done this time for v3.10 by KyongHo Cho, so it would be better
> to handle this cleanup with that at the same time.

You mean I should try to recheck the status of EXYNOS_DEV_SYSMMU around
(say) v3.10-rc1? If so, that's fine with me.


Paul Bolle

