Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaEPAjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:39:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21603 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaEPAjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:39:41 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-13-53755e3cd730
Date: Fri, 16 May 2014 09:39:24 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        t.figa@samsung.com, Will Deacon <will.deacon@arm.com>,
        tomasz.figa@gmail.com, joshi@samsung.com, s.nawrocki@samsung.com,
        Varun.Sethi@freescale.com, kgene.kim@samsung.com,
        prathyush.k@samsung.com, sachin.kamat@linaro.org, joro@8bytes.org,
        devicetree@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        grundler@chromium.org, linux-samsung-soc@vger.kernel.org,
        a.motakis@virtualopensystems.com, rahul.sharma@samsung.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        supash.ramaswamy@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document of
 Exynos System MMU
Message-id: <20140516093924.8ee826b9e7e346cb0144a0f1@samsung.com>
In-reply-to: <20140515203729.GA7136@mithrandir>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <6544270.ddFBoY6LMm@wuerfel> <20140428111802.GI19455@ulmo>
 <4780885.JaktFvJeC7@wuerfel> <20140515203729.GA7136@mithrandir>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t8zQ12buNJgg3VbrCzu3D3HavF30jF2
	i/lHgKxXR34wWXy8PJvZYsF+a4vO2RvYLb7v+sJu0bvgKpvFpsfXWC0u75rDZjHj/D4miwsr
	NrJbTFl0mNXi8Jt2VouTf3oZLY483M1u0XK9l8ni1cE2Fov1M16zWPzcNY/FYtWuP4wWM2+t
	YbF4+fEEi4OEx5OD85g81sxbw+jx+9ckRo/ZDRdZPP4d7mfy2DnrLrvHnWt72Dw2L6n3mHxj
	OaNHb/M7No++LasYPT5vkvO4cvQMk8fGuaEBfFFcNimpOZllqUX6dglcGYtuT2IpuCBZ8XXe
	QuYGxgfCXYycHBICJhLfln9khrDFJC7cW8/WxcjFISSwjFHi/bR7bDBFS3r/QyUWMUq0vpnL
	DOFMZpKY+uQfI0gVi4CqxIGtc5hAbDYBLYnVc4+DxUUEdCX+n37DAtLALLCGVWLf9/2sIAlh
	gQSJ0xeWgK3gFXCUmL30NNgdnAL6Eh+3vYNad4xR4t2y54wQd1hIXGjqYIdoEJT4MfkeC4jN
	DLRt87YmVghbXmLzmrdg50kIdHNKvOuBOIlFQEDi2+RDQA0cQAlZiU0HoJ6WlDi44gbLBEax
	WUjGzkIydhaSsQsYmVcxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihKSe/h2Mdw9YH2JMBlo5
	kVlKNDkfmLrySuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAMj92XGgpcGR763+t18vnrFuu0fj2x//5SFvS32thCTU1OTRdjxJxfuTu+Vy/DakiTZ
	8G+Hd6LF/tyFZyx2aZ7YpK4maqU0OTvsy6uIjTKRvA7lkw3Zty9d4Lxea7tv8e0b/8OYp9mK
	dKSL5bCtKWGZWXx8XaJPtl7oAlnVmxNuBrg/2vijblqPEktxRqKhFnNRcSIAHi+Y+FMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsVy+t9jAV2buNJggykHjS3u3D3HavF30jF2
	i/lHgKxXR34wWXy8PJvZYsF+a4vO2RvYLb7v+sJu0bvgKpvFpsfXWC0u75rDZjHj/D4miwsr
	NrJbTFl0mNXi8Jt2VouTf3oZLY483M1u0XK9l8ni1cE2Fov1M16zWPzcNY/FYtWuP4wWM2+t
	YbF4+fEEi4OEx5OD85g81sxbw+jx+9ckRo/ZDRdZPP4d7mfy2DnrLrvHnWt72Dw2L6n3mHxj
	OaNHb/M7No++LasYPT5vkvO4cvQMk8fGuaEBfFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
	pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5wGBQUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWYsuj2JpeCCZMXXeQuZGxgfCHcxcnJICJhILOn9zwZhi0lcuLceyObiEBJY
	xCjR+mYuM4QzmUli6pN/jCBVLAKqEge2zmECsdkEtCRWzz0OFhcR0JX4f/oNC0gDs8AaVol9
	3/ezgiSEBRIkTl9YAraCV8BRYvbS08wgNqeAvsTHbe+g1h1jlHi37DkjxB0WEheaOtghGgQl
	fky+xwJiMwNt27ytiRXClpfYvOYt8wRGgVlIymYhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjODE9kxqB+PKBotDjAIcjEo8vBe0SoOFWBPLiitzDzFKcDArifCetgUK8aYk
	VlalFuXHF5XmpBYfYkwGhsdEZinR5Hxg0s0riTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBsY43/zn6bpisn7bL874zj31cm6Z350dQsLRm47dPFElffzwre39
	voI79W1imjXyF59+2vJMJsx9YcXfL0eD9pp3MeeX+Zee4XPjefnxbdZsv6BP21subVrAtkeG
	7+i1V18mB8++w72VqVeGa2nn6kf7rihu2VzUUOWy/ZuiFTd7W7Fu8ST+m7uVWIozEg21mIuK
	EwHPQEpusAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 22:37:31 +0200, Thierry Reding wrote:
> On Mon, Apr 28, 2014 at 02:05:30PM +0200, Arnd Bergmann wrote:
> [...]
> > let me clarify by example:
> > 
> > 	iommu@1 {
> > 		compatible = "some,simple-iommu";
> > 		reg = <1>;
> > 		#iommu-cells = <0>; /* supports only one master */
> > 	};
> > 
> > 	iommu@2 {
> > 		compatible = "some,other-iommu";
> > 		reg = <3>;
> > 		#iommu-cells = <1>; /* contains master ID */
> > 	};
> > 
> > 	iommu@3 {
> > 		compatible = "some,windowed-iommu";
> > 		reg = <2>;
> > 		#iommu-cells = <2>; /* contains dma-window */
> > 	};
> > 
> > 	device@4 {
> > 		compatible = "some,ethernet";
> > 		iommus = <&/iommu@1>;
> > 	};
> > 
> > 	device@5 {
> > 		compatible = "some,dmaengine";
> > 		iommus = <&/iommu@2 0x40000000 0x1000000>,
> > 			 <&/iommu@3 0x101>;
> > 	};
> > 
> > The device at address 4 has a one-one relationship with iommu@1, so there
> > is no need for any data. device@5 has two master ports. One is connected to
> > an IOMMU that has a per-device aperture, device@5 can only issue transfers
> > to the 256MB area at 0x40000000, and the IOMMU will have to put entries for
> > this device into that address. The second master port is connected to
> > iommu@3, which uses a master ID that gets passed along with each transfer,
> > so that needs to be put into the IOTLBs.
> 
> iommu@3 and the second port of device@5 seem to match what we need for
> Tegra (and as I understand also Exynos). Can we settle on this for now
> so that Hiroshi and Cho can go update their drivers for this binding?
> 

Currently, Exynos IOMMU is the case of iommu@1.

But in the near future, it will support multiple masters with a single context
that means all masters that shares a single System MMU also views the same
address space.

For some cases, we may need iommu@3 that supports dma-window.

So, I have no other opinion.

By the way, iommu framework should allow to process the parameters
to 'iommus' property in the master nodes by iommu driver implementations
because it is depended on implementations.

> > A variation would be to not use #iommu-cells at all, but provide a
> > #address-cells / #size-cells pair in the IOMMU, and have a translation
> > as we do for dma-ranges. This is probably most flexible.
> 
> The remainder of this discussion seems to indicate that #iommu-cells and
> dma-ranges don't have to be mutually exclusive. For some IOMMUs it might
> make sense to use both.
> 
> In fact perhaps we should require every IOMMU user to also specify a
> dma-ranges property, even if for some cases the range would be simply
> the complete physical address space. Perhaps in analogy to the ranges
> property an empty dma-ranges property could be taken to mean all of the
> physical address space.
> 
> I'm aware that this doesn't cover any of the more exotic cases out
> there, but the fact is that we have real devices out there that ship
> with some variations of these simple IOMMUs and I don't think we're
> doing ourselves a favour by blocking support for these to be added on
> the hope of merging the perfect solution that covers all use-cases.
> Patches for Tegra have already been around for close to half a year.
> 
> Thierry
