Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbaCSJII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:08:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16889 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbaCSJIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:08:00 -0400
X-AuditID: cbfee68f-b7f156d00000276c-3b-53295e6e19c1
Date: Wed, 19 Mar 2014 18:07:57 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v11 19/27] iommu/exynos: add support for power management
 subsystems.
Message-id: <20140319180757.a1552386b81e698914d4bcc6@samsung.com>
In-reply-to: <53286730.1060807@samsung.com>
References: <20140314141028.4b0b62d895905988ab5dda88@samsung.com>
 <53232959.7020306@samsung.com>
 <20140318202320.a3101304bbc51cc9f169cdaa@samsung.com>
 <53286730.1060807@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t8zI938OM1gg0cTGS3u3D3HarFxxnpW
	i/lHgKxXR34wWSzYb23ROXsDu0XvgqtsFl8Pr2C02PT4GqvF5V1z2CxmnN/HZPHm9wt2i7VH
	7rJbXFixkd1iyqLDrBZnTl9itTj8pp3V4uSfXkaL9TNes1gcXxtuMfPWGhYHUY8nB+cxeayZ
	t4bRY3bDRRaPf4f7mTzuXNvD5rF5Sb3H5BvLGT22XG1n8ejbsorR4/MmOY8rR88wBXBHcdmk
	pOZklqUW6dslcGXc2LGDtWAvV8X+TwfYGxhXcXQxcnJICJhIXFrznh3CFpO4cG89WxcjF4eQ
	wDJGiYtXD7HBFG29/4gRIrEIKNFzAsqZzCQx4+U9VpAqFgFVifeH7zGC2GwCWhKr5x4Hs0UE
	VCQun5oO1sAs0M8ucXHXLrB9wgLREm9vrgVr5hVwlPj75i1LFyMHB6eAtsSKlXwQC3YzSkyY
	cxXqDAuJC00d7BD1ghI/Jt9jAbGZgZZt3tbECmHLS2xe85YZpFlC4AGHxOuLf5ggrhOQ+Db5
	ENgCCQFZiU0HmCFmSkocXHGDZQKj2CwkY2chGTsLydgFjMyrGEVTC5ILipPSi4z1ihNzi0vz
	0vWS83M3MUKSR/8OxrsHrA8xJgOtnMgsJZqcD0w+eSXxhsZmRhamJqbGRuaWZqQJK4nz3n+Y
	FCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcc2pO1OZzjX1ZVoeWLwzobbR+/+VSVM2bbll
	w/1hR8P/rat/L53/YPXLBVcyF9zxv9X4++lMy8n8W7h1F3a9fbg1fVLHrpiy9WGJR9e9idTz
	zV9yqGty4bPwix8cmM6E3NRfFNuppvxw11TL10r/52l+/6J2q1w1cnfqI9XPnGkMQkxTAl/8
	zOBXYinOSDTUYi4qTgQAmWuGsjQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t9jAd28OM1gg/Yf5hZ37p5jtdg4Yz2r
	xfwjQNarIz+YLBbst7bonL2B3aJ3wVU2i6+HVzBabHp8jdXi8q45bBYzzu9jsnjz+wW7xdoj
	d9ktLqzYyG4xZdFhVoszpy+xWhx+085qcfJPL6PF+hmvWSyOrw23mHlrDYuDqMeTg/OYPNbM
	W8PoMbvhIovHv8P9TB53ru1h89i8pN5j8o3ljB5brrazePRtWcXo8XmTnMeVo2eYArijGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AeVVIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3Nixg7VgL1fF/k8H2BsYV3F0MXJy
	SAiYSGy9/4gRwhaTuHBvPVsXIxeHkMAiRomLPScYIZzJTBIzXt5jBaliEVCVeH/4HlgHm4CW
	xOq5x8FsEQEVicunpoM1MAv0s0tc3LWLHSQhLBAt8fbmWrBmXgFHib9v3rJ0MXJwcApoS6xY
	yQexYDejxIQ5V9kgzrCQuNDUwQ5RLyjxY/I9FhCbGWjZ5m1NrBC2vMTmNW+ZJzAKzEJSNgtJ
	2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKemZ1I7GFc2WBxiFOBgVOLhPRCl
	ESzEmlhWXJl7iFGCg1lJhFf4LlCINyWxsiq1KD++qDQntfgQYzIwOCYyS4km5wPTZl5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MG6+9EVqqtpO+9DCP5rH
	Xf0mLZv3YoatpkaI94S6J3UXj2zYU3hp+pPzXQsU3cOlH/OziCz1c/NeLHv+3/aGpadUMrg9
	9F7N+ap9Q/reXDsTwRXXeaLi2JTmrrPSytv7TFnq2R7fp0E6f39qn02xiyo72TLF7cWRrSf+
	hlSpRb36GmLr+0HeSE+JpTgj0VCLuag4EQC4HuthkQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 16:33:04 +0100, Tomasz Figa wrote:
> On 18.03.2014 12:23, Cho KyongHo wrote:
> > On Fri, 14 Mar 2014 17:07:53 +0100, Tomasz Figa wrote:
> >> Hi KyongHo,
> >>
> >> On 14.03.2014 06:10, Cho KyongHo wrote:
> 
> [snip]
> 
> >>> @@ -677,11 +679,40 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >>>    	platform_set_drvdata(pdev, data);
> >>>
> >>>    	pm_runtime_enable(dev);
> >>> +	data->runtime_active = !pm_runtime_enabled(dev);
> >>
> >> Hmm, this seems to be a bit misleading. The field is named
> >> runtime_active, but the assignment makes it true if PM runtime is _not_
> >> enabled (i.e. inactive). Is this correct?
> >>
> >
> > I agree that it may lead misunderstood.
> > data->runtime_active actually indicates if electric power is asserted
> > to the System MMU. pm_runtime_enable() call must enable runtime pm
> > for the given device. If runtime pm is not enabled although pm_runtime_enable()
> > is called, CONFIG_PM_RUNTIME is not configured.
> >
> > Actually, it is replacible with
> > if (IS_ENABLED(CONFIG_PM_RUNTIME))
> >      data->runtime_active = true;
> 
> I would keep it as !pm_runtime_enabled(dev), but rename the field to 
> something more meaningful, like data->is_powered_on.
> 

That is good idea.

thanks for advice.

KyongHo.
