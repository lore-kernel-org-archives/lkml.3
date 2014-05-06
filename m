Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaEFSWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:22:00 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56746 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEFSV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:21:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Joerg Roedel <joro@8bytes.org>,
        Shaik Ameer Basha <shaik.samsung@gmail.com>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "supash.ramaswamy" <supash.ramaswamy@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        sunil joshi <joshi@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v12 00/31] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
Date: Tue, 06 May 2014 20:21:48 +0200
Message-ID: <4231522.iA1YhEv1iL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140506175904.GB12376@8bytes.org>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <CAOD6ATqZ5UwRwSKiPDQLrgmX=UUrJVE7ybM_RhXz_CEUjM3W7w@mail.gmail.com> <20140506175904.GB12376@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QbEYaB0RjynEi5GHTDUYyZ6rR2S00aL8nKjdl53P5uT
 +gR5vPn5QKjB0uVdENm3xe2j2pyHI1VTOVceCoicrnRZd48ruK
 WrCWACRvm/4C3UyaqUwAz0Rmi+EdyQJRa/vVy0eJXQitYzj6V5
 TOOBHGoWiIZKjbGAR9yqwPdh3DVp+UbYfdy33PA8gOKxjZVTZe
 1Cgzc5o/ljxhYGwHg6PbHN95cC1b946hHuiiGQTlI4zt2JgEpf
 ftpP6fnlAvo+J1BUaEbDbOlnPineuvB5jU7qUy+Rd8D62/G2tL
 vGI4WphS3tCA6Um4skYj/hMWAOxXAQyJtqIvoeRsq+Edll8foH
 I9+vnSty5RwFQMwo8xrU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 19:59:05 Joerg Roedel wrote:
> On Wed, Apr 30, 2014 at 04:27:10PM +0530, Shaik Ameer Basha wrote:
> > This series is going on for quite a long time and most of the patches here
> > doesn't depend on dt bindings. As Exynos IOMMU h/w is introducing new versions
> > very frequently, maintaining and reviewing all these patches again and
> > again is quite a hard job.
> > 
> > If it is acceptable, I can post one more series with the subset of
> > above patches,
> > which doesn't depend on dt-bindings. As all the patches which doesn't depend on
> > DT bindings are already tested,  I hope merging these subset of patches may help
> > in reducing the rework and review effort every time.
> > 
> > Once we finalize the generic DT bindings for the IOMMU devices, the driver
> > can be updated with the proposed DT bindings in mind.
> 
> Sounds reasonable to me if the patch subset is self-contained. When
> Arnd is OK with that and no one else has objections I can take the
> dt-independend parts.

Sounds good to me.

	Arnd
