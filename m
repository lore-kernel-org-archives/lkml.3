Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbbAWGlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:41:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44082 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbbAWGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:41:25 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-1d-54c1ed13263c
From: Kukjin Kim <kgene@kernel.org>
To: "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Inha Song'" <ideal.song@samsung.com>, alsa-devel@alsa-project.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, robh+dt@kernel.org, kgene@kernel.org,
        galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
 <1421925482-15861-4-git-send-email-ideal.song@samsung.com>
 <54C0EC23.9070209@samsung.com>
In-reply-to: <54C0EC23.9070209@samsung.com>
Subject: RE: [alsa-devel] [PATCH v3 3/4] ARM: dts: set clock out parent to
 XUSBXTI
Date: Fri, 23 Jan 2015 15:41:22 +0900
Message-id: <0b7f01d036d7$9a438850$ceca98f0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJACE3MZBEZlIXi7s4ZLJJ9PYKWbwD3re5VAlTR3xub0zoEQA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUhUYRSG+e69c70zzMBt1PqcqGRCECvNZewTMyIQ7q8WMgT7YdN0XdBR
	mVFpg8xWzdRyZczS0HJLaxQcLScdLStzy61FR0Wd3MGl0XAhx2vgv/dwznue98ChcHEFT0KF
	RkSzqgh5uJQUEC3rJrdD1jMNfofnsynU3WnAUMbwKImeNbXxUMp0Pg/Vr+oAql0bBKhtshig
	lJEpHJm772NIO9LLQ121T0iU3a7H0K8uESrs68RQatYrAt2pa7JCjdP3eKizaBFDE5XT2HFr
	5vVCPMmUPS0DzO1bSSTTlfwQY2o0A1ZM8ctFktGWJJBMf+87kqksuMEkV5UAprLlGrOg3Xta
	GCA4eokND41lVS7HLghC1j4b8aiP/Msl32RxoMcqEfApSHtAs/k5wemdsMNYQSYCASWmXwA4
	nFlN/h/Sf5jEuEYWgBVjqzhXrAFo0o9vFBRF0vvhzXgXi8GadoL5VfGbW23oWNhZ2g0sGqcf
	43AlI5TzFgDY9yAPtzT49AE4Vq234sx+MGlyhWfRBO0ATXNLmEWLaASb89YBp3fA5TQjwS11
	ghU1zRin98HKshmcS20Pda1TW2AbqB+fBVygE3DJrNk8ANLLFMwt/bIFo6E5zUBYjoH0Hqit
	39pjBxuKvhOpwE6zDa3ZhtZsQ2u24fIAUQJs2ShFlPpisMrDWS1XqmMigp0VkUot4P4oVQeM
	9d4GQFNAKhTFVTX4iXnyWPUVpQHINhI9wiW2isiN14uIDnR193RDMg+Zu9sRL0/pLtGU5O9Z
	MR0sj2bDWDaKVQWqYsJZtQFgFF8SB5TSBBDggMmEc8SfjlSdt2+6eLVO+Ht3/3yHImygvIdP
	y9+fGu1TNq4NrQ7yJkzCiZb0cq+Vn5GqosIcx1bJW75/9lW7obt11zOTw772aZsDaftq3Un9
	ORsyNyvHV/AD+pxPV5a2HMwMErVPnfHxD6pZltXbLRlndZFZjm8+SQl1iNzVCVep5f8Aottr
	pkIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jQV3htwdDDBbtZLK4cvEQk8XUh0/Y
	LOYfOcdq0f9mIavFgT87GC12/b3PaHHu1UpGi/7Hr5ktvl3pYLLY9Pgaq8XlXXPYLGac38dk
	cfsyr8XS6xeZLCZMX8ti0br3CLvF4TftrBYXV3xhsni5+Q2Tg7DHhs9NbB5r5q1h9Ghp7mHz
	uNzXy+Sxc9Zddo+Vy7+weWxa1cnmcefaHjaPzUvqPfq2rGL02Hy62uPzJrkAnqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoB+VFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBl/T95jLjjGWbHqkmkD41X2LkZODgkBE4l9
	R18xQdhiEhfurWfrYuTiEBKYziix/ukfZgjnL6PEs30vgBwODjYBZYnGJn2QBmEBLYmFW5pY
	QGwRgTKJi6uvMILYzAKTmCV+T82E6F3CKHG9ewEzSIJTQFvi6fZ97BDNIRI9r36zgtgsAqoS
	zz5+B7uCV8BC4viCf4wQtqDEj8n3WCCGakms33mcCcKWl9i85i0zxNUKEjvOvoZaLCKx78U7
	RoiDnCS+f5vFPIFReBaSUbOQjJqFZNQsJO0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgQnu2dSOxhXNlgcYhTgYFTi4W3YcjBEiDWxrLgy9xCjBAezkghv9yOgEG9KYmVValF+fFFp
	TmrxIUZToE8nMkuJJucDE3FeSbyhsYmZkaWRmYWRibm5kjivkn1biJBAemJJanZqakFqEUwf
	EwenVAPj8ReHXbwtN9+w3/fl9EeNhxub9Ovt/i+5vE9n/dm0HQ+TlT+dtWoJspVgKO2Ilvep
	39a7TD35czoLW+Oprt5PNvX+6xZXSH2T1LL/vyvBzPTZYvGDGbevsd/w/skjy/NXZ+/e589P
	2CSz7S8/r1a1NvilkU3vw+XulVccSn+utRTPyeBskZyuxFKckWioxVxUnAgAEeM7rYwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sylwester Nawrocki wrote:
> 
> On 22/01/15 12:18, Inha Song wrote:
> > This patch set clock out parent to XUSBXTI.
> >
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos4.dtsi | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> > index b8168f1..020bbaf 100644
> > --- a/arch/arm/boot/dts/exynos4.dtsi
> > +++ b/arch/arm/boot/dts/exynos4.dtsi
> > @@ -141,6 +141,8 @@
> >  	pmu_system_controller: system-controller@10020000 {
> >  		compatible = "samsung,exynos4210-pmu", "syscon";
> >  		reg = <0x10020000 0x4000>;
> > +		assigned-clocks = <&pmu_system_controller 0>;
> > +		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
> >  	};
> 
> Looks good, except it needs to be done only for the Trats2 board, i.e.
> the PMU device node including these properties should be added to
> exynos4412-trats2.dts.  I think it's fine to make it a one patch including
> all dts changes.
> 
Yeah, I agree with Sylwester's suggestion. Please make a one patch for the
updating DT for sound support and adding me in Cc for the change for relevant
driver changes as well.

Thanks,
Kukjin

