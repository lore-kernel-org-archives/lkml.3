Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaIBIau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:30:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59147 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaIBIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:30:45 -0400
X-AuditID: cbfee68e-f79536d000000fd1-49-540580336579
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Lee Jones'" <lee.jones@linaro.org>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, naushad@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com,
        linux-samsung-soc@vger.kernel.org, broonie@kernel.org,
        thomas.ab@samsung.com, chow.kim@samsung.com
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
 <3343901.7HpqcTBEp1@wuerfel> <20140902080516.GE17117@lee--X1>
 <3109076.4UMHArqVbl@wuerfel>
In-reply-to: <3109076.4UMHArqVbl@wuerfel>
Subject: RE: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Tue, 02 Sep 2014 14:02:48 +0530
Message-id: <001401cfc688$85c07bf0$914173d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHpa/2m/d4/OY0ITARCUM8RI+G5jQHOmKtTAm8SxMwCNVQ9I5uGn1Gg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkVte4gTXEYGe7jMXfScfYLaY+fMJm
	sWzSXTaL77u+sFv0LrjKZnH/61FGi02Pr7FaXN41h81ixvl9TBa3L/NafDr6n9Vi/YzXLBYd
	yxgtbj7bzuTA59HS3MPm8fvXJEaPTas62TzuXNvD5rF5Sb1H35ZVjB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZfzatIy94J5kxcfbPSwNjJtEuhg5OCQETCSO9pp1MXICmWISF+6tZ+ti5OIQEljK
	KHHu9jIWiISJxIz3L9lBbCGBRYwS23tdIYr+Mko8nLKQDSTBJqAr8eT9XGYQW0TAU+LMyQUs
	IEXMAseZJI7tmMAC0bGcUeL+g4tgozgFNCW+NUxlBLGFBfwlvtxbDNbNIqAq0TX3JZjNK2Ap
	cejkUiYIW1Dix+R7YCcxC2hJrN95nAnClpfYvOYtM8SpChI7zr5mhLjCTeL4zImsEDXiEpMe
	PGQHOUJCYCmHxIPn3xkhlglIfJt8iAUSFrISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5Cs
	WMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMCmc/vesbwfjzQPWhxgFOBiVeHglfrCE
	CLEmlhVX5h5iNAW6aCKzlGhyPjD15JXEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwCj66Nvxd7Wcr3dkr5R8fJ8l6siyV7FmMmW+hm3//GK/7uznUT34
	+sPhaUoyy5or70ZP3XivzC9nwg8Wn9YJbevvhFzZvjo9Wf3YDg3/extEL/400GKZ9nFz6Y+t
	OnJ5E4VW895ae6nj9xfPhxszVSMlWZvFrU9stj6T7/NVZ459nz4r56bJj32VWIozEg21mIuK
	EwGTjOBIBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAV3jBtYQg4l7hSz+TjrGbjH14RM2
	i2WT7rJZfN/1hd2id8FVNov7X48yWmx6fI3V4vKuOWwWM87vY7K4fZnX4tPR/6wW62e8ZrHo
	WMZocfPZdiYHPo+W5h42j9+/JjF6bFrVyeZx59oeNo/NS+o9+rasYvT4vEkugD2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hiJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGr03L2AvuSVZ8vN3D0sC4SaSLkZNDQsBE
	Ysb7l+wQtpjEhXvr2UBsIYFFjBLbe127GLmA7L+MEg+nLARLsAnoSjx5P5cZxBYR8JQ4c3IB
	C0gRs8BxJoljOyawQHQsZ5S4/+Ai2FhOAU2Jbw1TGUFsYQF/iS/3FoN1swioSnTNfQlm8wpY
	Shw6uZQJwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQpypI7Dj7mhHiCjeJ4zMnskLUiEtM
	evCQfQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOOs+k
	dzCuarA4xCjAwajEwyvxgyVEiDWxrLgy9xCjBAezkgjvi0TWECHelMTKqtSi/Pii0pzU4kOM
	pkCfTmSWEk3OBybEvJJ4Q2MTc1NjU0sTCxMzSyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFIN
	jFO3RobO3RUs4/abwUWap/9zya7Qfi62xHVyG3XK1KZlGDxbcfvhpQKx0MpDPrnWsfOmf9W0
	4ynleB8t8fnkjnpjuzTpwvc7b9xwU1pRmlt/5FGBxy9BhhjrTdK8x3m4zy7NNt0RvmrJZt7P
	93aw/FRtEOo8P3/CP23/Ut0T3J3LhYzOX2+Zp8RSnJFoqMVcVJwIAPwH0RFQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, September 02, 2014 1:45 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Lee Jones; kgene.kim@samsung.com; linux@arm.linux.org.uk;
> naushad@samsung.com; Pankaj Dubey; Tomasz Figa;
linux-kernel@vger.kernel.org;
> joshi@samsung.com; vikas.sajjan@samsung.com; linux-samsung-
> soc@vger.kernel.org; broonie@kernel.org; thomas.ab@samsung.com;
> chow.kim@samsung.com
> Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon
devices
> 
> On Tuesday 02 September 2014 09:05:16 Lee Jones wrote:
> > On Mon, 01 Sep 2014, Arnd Bergmann wrote:
> >
> > > On Monday 01 September 2014 17:04:26 Lee Jones wrote:
> > > > On Mon, 01 Sep 2014, Arnd Bergmann wrote:
> > > > > Maybe I'm misreading the patch, but I don't see how it creates a
> > > > > migration path. What I want to end up with is infrastructure
> > > > > that lets anybody call syscon_regmap_lookup_by_pdevname or
> > > > > syscon_regmap_lookup_by_compatible (if they really need to)
> > > > > without needing the platform_driver for syscon. That should not
> > > > > require any form of compatibility layer because to the driver
> > > > > using it there is no API change.
> > > >
> > > > Somehow I think the likelyhood is that I am misreading the patch.
> > > >
> > > > I thought that before this patch drivers we had to register a
> > > > syscon device to bind to this driver, which was fine for the first
> > > > use-cases of syscon as it wasn't required too early during boot.
> > > > However, now there are use-cases where systems require access to
> > > > syscon registers eariler in boot we require a means to obtain
> > > > access prior to device probing.  I thought this patch not only
> > > > provides that possibilty, but also leaves in the ability to register
direct from
> DT.
> > >
> > > Right, it does provide the ability to have syscon before devices are
> > > registered, I missed that part.
> > >
> > > > > In contrast, this patch introduces a new
> > > > > of_syscon_{un,}register() interface that would get removed after
> > > > > the the above has been implemented, causing extra churn for any
> > > > > driver that also wants to provide a regmap-like interface.
> > > >
> > > > When will we ever not have to register syscon?
> > >
> > > The idea is that we implicitly register the syscon block when
> > > someone calls syscon_regmap_lookup_by_compatible or
> > > syscon_regmap_lookup_by_phandle and then return a reference to that
> > > new syscon. When another driver looks up the same device node, we
> > > just pass a reference to the existing syscon.
> >
> > Doesn't sound too unreasonable.  So how about instead of exporting
> > these new of_syscon_{un,}register() calls, we make them static and
> > call them from syscon_regmap_lookup_by_{phandle,compatible}?
> 
> Yes, that would be a good start. We should think about whether we want to
remove
> the existing DT probing at the same time, since it becomes unused, and we
might
> want to move the code to drivers/base/regmap_*.c at some point.
> 


OK, I am working on these two parts. Once code is in proper form and tested
on
our setup I will post here.

Thanks,
Pankaj

> 	Arnd

