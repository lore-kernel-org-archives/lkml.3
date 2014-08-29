Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaH2IDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:03:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40148 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaH2ICg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:02:36 -0400
X-AuditID: cbfee691-f79546d0000011a1-42-5400339801c7
Date: Fri, 29 Aug 2014 17:02:30 +0900
From: Inha Song <ideal.song@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v3 1/2] mfd: arizona: Add support for
 INn_Modec register control
Message-id: <20140829170230.673ca9ff@songinha-Samsung-DeskTop-System>
In-reply-to: <20140828113651.GN24579@lee--X1>
References: <20140818200003.2ab8aca0@songinha-Samsung-DeskTop-System>
 <20140828113651.GN24579@lee--X1>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsWyRsSkUHeGMUOIQVenqMWVi4eYLKY+fMJm
	8W/KDXaL61+es1rMP3KO1aL/zUJWi3OvVjJa3P96lNHi25UOJovLu+awWSy9fpHJYvnb/2wW
	E6avZbFo3XuE3eJ0N6sDv8eGz01sHmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxa1cnmcefaHjaP
	eScDPV5O/M3m0bdlFaPH501yAdxRXDYpqTmZZalF+nYJXBkdp+exFawXqJj16D1zA2Mnbxcj
	J4eEgIlE35O9LBC2mMSFe+vZuhi5OIQEljJKXN05nwWmqLnzCpgtJDCdUeL9FU+Ion4miYfb
	ljN3MXJwsAioSny5qAVSwyagIfH982awsIiAisS5N+Yg5cwC35kk+k8+AosLCyRLnLzKClLO
	K+Aq0bzjJDuIzSmgKzH36AGoVRkSr5csY4M4wUZi9c51zBD1ghI/Jt8Dq2EWUJeYNG8RM4St
	LfHk3QVWiPq1HBJH3viC2CwCAhLfJh9iAVkrISArsekAM0SJpMTBFTdYJjCKzUIydRaSqbOQ
	TF3AyLyKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzDyT/97NnEH4/0D1ocYBTgYlXh4O07+
	DxZiTSwrrsw9xGgKdMVEZinR5HxgeskriTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoEx4nre89IjOZ9DG6+U/JycN38p5x6/4xqrp8dpWG+dwFrz7b/h
	L33xaRnxW3RXfZPn5lwzx+vzzvjMpf5PCphEYt8kP96qucNIk0XoWq6Yj4pFXEyjxqHGmXPl
	8s0YN/V/4dxx5ODW0kfGQkF5ux+XXVtbs2LLhCb9j7Mt1X3On+T7rFYjtY9HiaU4I9FQi7mo
	OBEATRY+8fcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd0ZxgwhBl97eCyuXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOY0XF6HlvBeoGKWY/eMzcwdvJ2MXJySAiYSDR3XmGBsMUkLtxbzwZiCwlMZ5R4f8Wzi5EL
	yO5nkni4bTlzFyMHB4uAqsSXi1ogNWwCGhLfP28GC4sIqEice2MOUs4s8J1Jov/kI7C4sECy
	xMmrrCDlvAKuEs07TrKD2JwCuhJzjx5ggViVIfF6yTI2iBNsJFbvXMcMUS8o8WPyPbAaZgF1
	iUnzFjFD2NoST95dYJ3AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iRGcWJ5J7WBc2WBxiFGAg1GJh7fj5P9gIdbEsuLK3EOMEhzMSiK8xw0ZQoR4UxIrq1KL8uOL
	SnNSiw8xmgLDYiKzlGhyPjDp5ZXEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C
	6WPi4JRqYFyT12T3InSeALfT85nTp1zyVN72+V+mhRXL6tu+ijulpDsri6Yva9TJbPjMxXpr
	sb3OsYldlvmfItiCK1YKCk0K/a07v+5HjqXNAbsS54/1T806bmnOmfJB5k+ZecD35otaO/cl
	n/0iPXd6zwF1puyIgBBVp9IFDQfd+bdd2d26uv1/kObhF0osxRmJhlrMRcWJAOt6tJNCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lee
Thanks for your review.

On Thu, 28 Aug 2014 12:36:51 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> On Mon, 18 Aug 2014, Inha Song wrote:
> 
> > Some boards need to set the INn_MODE[1:0] register to change
> > the input signal patch. This wlf,inmode property is optional.
> > If present, values must be specified less than or equal to
> > the number of input singals. If values less than the number
> > of input signals, elements that has not been specifed are set
> > to 0 by default.
> > 
> > Example:
> >    - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  drivers/mfd/arizona-core.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > index 10a0cb9..81e6db8 100644
> > --- a/drivers/mfd/arizona-core.c
> > +++ b/drivers/mfd/arizona-core.c
> > @@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
> >  static int arizona_of_get_core_pdata(struct arizona *arizona)
> >  {
> >  	struct arizona_pdata *pdata = &arizona->pdata;
> > -	int ret, i;
> > +	int ret, i, proplen;
> >  
> >  	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
> >  
> > @@ -560,6 +560,12 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
> >  			ret);
> >  	}
> >  
> > +	proplen = of_property_count_u32_elems(arizona->dev->of_node,
> > +					      "wlf,inmode");
> > +	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode))
> > +		of_property_read_u32_array(arizona->dev->of_node, "wlf,inmode",
> > +					   arizona->pdata.inmode, proplen);
> 
> of_property_for_each_u32()?

Is it more clear to use of_property_for_each_u32() instead of
of_property_read_u32_array()?

If so, I will fix in v5.

Best regards,
Inha Song.

> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
