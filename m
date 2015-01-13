Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbbAMB1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:27:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25747 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbAMB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:27:38 -0500
X-AuditID: cbfee68d-f79296d000004278-20-54b4748774f2
Date: Tue, 13 Jan 2015 10:27:34 +0900
From: Inha Song <ideal.song@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com, tiwai@suse.de,
        robh+dt@kernel.org, kgene@kernel.org, s.nawrocki@samsung.com,
        galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: samsung: Document Trats2 audio
 subsystem bindings
Message-id: <20150113102734.7a3aa77a@songinha-Samsung-DeskTop-System>
In-reply-to: <20150105152918.GT11764@sirena.org.uk>
References: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
 <1420457117-11030-3-git-send-email-ideal.song@samsung.com>
 <20150105152918.GT11764@sirena.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWyRsSkULe9ZEuIwYa9phZXLh5ispj68Amb
	xfwj51gt+t8sZLU48GcHo8W5VysZLfofv2a2+Halg8li0+NrrBaXd81hs5hxfh+Txe3LvBZL
	r19kspgwfS2LReveI+wWh9+0s1pcXPGFyeLl5jdMDkIeGz43sXmsmbeG0aOluYfN43JfL5PH
	zll32T1WLv/C5rFpVSebx51re9g8Ni+p9+jbsorRY/Ppao/Pm+QCeKK4bFJSczLLUov07RK4
	Ms4/3shW0M9W8bJlB3sD432WLkZODgkBE4mJ1/uZIGwxiQv31rN1MXJxCAksZZTY2riFEabo
	yaatUInpjBLrTqxihXD6mSRerv0LNopFQFXi2qVuMJtNQEPi++fNzCC2iICyxNXve1lAGpgF
	tjJL/Lr9EiwhLBAvcej3AbDdvAKuEuuvzAOzOQWMJX63HmeE2LCGUeJr7zyoA20kVu9cxwzR
	ICjxY/I9sG3MAloSm7c1sULY8hKb17xlBmmWEDjBIfHt9Bs2iPMEJL5NPgTUwAGUkJXYdIAZ
	YqakxMEVN1gmMIrNQjJ2FpKxs5CMXcDIvIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMFWc
	/vesdwfj7QPWhxgFOBiVeHh3ZG8JEWJNLCuuzD3EaAp0xURmKdHkfGBCyiuJNzQ2M7IwNTE1
	NjK3NFMS51WU+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVH3f/0h7ryS99PmXf/4K0Vo
	w/3nvVttlT88c306UyOucFfoKsuuHY8m6J7VfWCywrzh1Ip3BV8n/jsv839z1kqr8thr+jFN
	ii8PT/2l8ZkrR9X8vq2RZf3TT1bXCjYscI48Y6ItlWTvVesRsIJrls2xNSeMxG6dDpvlHDv/
	nHPwF/kLZpGnO+4rsRRnJBpqMRcVJwIAc9oaxRADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd32ki0hBq3LdCyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotzr1YyWvQ/fs1s8e1KB5PFpsfXWC0u75rDZjHj/D4mi9uXeS2W
	Xr/IZDFh+loWi9a9R9gtDr9pZ7W4uOILk8XLzW+YHIQ8NnxuYvNYM28No0dLcw+bx+W+XiaP
	nbPusnusXP6FzWPTqk42jzvX9rB5bF5S79G3ZRWjx+bT1R6fN8kF8EQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAL2npFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcw4/3gjW0E/W8XLlh3sDYz3WboYOTkkBEwknmzaygZh
	i0lcuLceyObiEBKYziix7sQqVginn0ni5dq/YB0sAqoS1y51g9lsAhoS3z9vZgaxRQSUJa5+
	38sC0sAssJVZ4tftl2AJYYF4iUO/DzCB2LwCrhLrr8wDszkFjCV+tx5nhNiwhlHiay9EQkLA
	RmL1znXMEA2CEj8m3wPbxiygJbF5WxMrhC0vsXnNW+YJjAKzkJTNQlI2C0nZAkbmVYyiqQXJ
	BcVJ6blGesWJucWleel6yfm5mxjBieiZ9A7GVQ0WhxgFOBiVeHgF8raECLEmlhVX5h5ilOBg
	VhLhXWkDFOJNSaysSi3Kjy8qzUktPsRoCgyPicxSosn5wCSZVxJvaGxiZmRpZG5oYWRsriTO
	q2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAaJBu+fLJ5t3XXt69ZbTDItHKp7y9Ye7t+vSp9oqb
	7okYSXVv96oPUrFf+4dv7/vOzKwcuxsGyW897k92/8Dh5t34acrWqPDHTNw/JmwMWdE0+5T7
	ripG39cXJvtO8PBPmmByys7979SVVfeE7BQnRWa0fPfK8lK05fwgu+flQbs3Ad/0Jqz+p8RS
	nJFoqMVcVJwIABGhwq9aAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thank you for your feedback and sorry for late response.

I think, I should remove clock settings in machine driver.
If the clock settings are necessary, I will add "assigned-clocks" nodes
in trats2 sound DT like odroid board.

Best Regards,
Inha Song.

> On Mon, Jan 05, 2015 at 08:25:16PM +0900, Inha Song wrote:
> 
> > + - clocks : Reference to the codec master clock
> > + - clock-names : The clock should be named "mclk"
> 
> This should be done in the CODEC driver, not in the machine driver - the
> CODEC always needs the clock, it's not something specific to this
> machine.  Even if we decide that for Linux the best thing to do is to
> manage the clock in the machine driver it should be described in the DT
> as being attached to the CODEC.
