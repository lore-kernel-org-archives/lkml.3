Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaLRHnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:43:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38580 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaLRHnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:43:03 -0500
X-AuditID: cbfee68d-f79296d000004278-7b-54928584831c
Date: Thu, 18 Dec 2014 16:42:58 +0900
From: Inha Song <ideal.song@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        ckeepax@opensource.wolonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel][PATCH 1/2] mfd: arizona: Add support for OUTn_MONO
 register control
Message-id: <20141218164258.6785ca4e@songinha-Samsung-DeskTop-System>
In-reply-to: <20141209085717.GT3951@x1>
References: <1418030422-27061-1-git-send-email-ideal.song@samsung.com>
 <1418030422-27061-2-git-send-email-ideal.song@samsung.com>
 <20141209085717.GT3951@x1>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkWLeldVKIwbJznBZTHz5hs/iz7zij
	xfwj51gt+t8sZLU492olo8X9r0cZLS7vmsNmsfT6RSaL5W//s1lMmL6WxaJ17xF2i9PdrA48
	HmvmrWH0uNzXy+SxcvkXNo9NqzrZPO5c28PmMe9koMfLib+BQnt+M3t83iQXwBnFZZOSmpNZ
	llqkb5fAlTHr7FWmgja+iv7DL9kaGP9xdTFyckgImEhs376SDcIWk7hwbz2QzcUhJLCUUeLI
	zgXMMEWXD05nhkhMZ5S4PPkSC0hCSKCfSWLZuzAQm0VAVeLxzStgcTYBDYnvnzcDNXBwiAio
	SJx7Yw7Syyywikni4t2t7CA1wgLxEpdWr2IFsXkFXCWaNl8AW8YpoC6x9PJfFohlCxglFjVP
	hrrCRmL1znXMEA2CEj8m3wNbxgzUMGneImYIW1viybsLrCDNEgKdHBJdDQ/ZIK4TkPg2+RAL
	yEUSArISmw5AzZSUOLjiBssERrFZSMbOQjJ2FpKxCxiZVzGKphYkFxQnpRcZ6hUn5haX5qXr
	JefnbmIExvPpf896dzDePmB9iFGAg1GJh1dSb1KIEGtiWXFl7iFGU6ArJjJLiSbnA5NGXkm8
	obGZkYWpiamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDwZpjdyFIzd
	dlk+LzTfc+2liXs111luUfd5mxeuOsnq+jlxS4yo3sQD9lNeqzaEHEucPd1zx/9ta4oU1hqZ
	5HerbTT780bpV8/eGjvdOr//UoFL2X245m2r4lHIdvZ5uWjzWa1p2VukJnNEPrwiLrVHy/9U
	15WJTc9tZ6tkHvH4rbQzfINXnRJLcUaioRZzUXEiAOU6V23iAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd2W1kkhBi9OMFpMffiEzeLPvuOM
	FvOPnGO16H+zkNXi3KuVjBb3vx5ltLi8aw6bxdLrF5kslr/9z2YxYfpaFovWvUfYLU53szrw
	eKyZt4bR43JfL5PHyuVf2Dw2repk87hzbQ+bx7yTgR4vJ/4GCu35zezxeZNcAGdUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDJSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMWWevMhW08VX0H37J1sD4j6uLkZNDQsBE
	4vLB6cwQtpjEhXvr2boYuTiEBKYzSlyefIkFJCEk0M8ksexdGIjNIqAq8fjmFbA4m4CGxPfP
	m4GaOThEBFQkzr0xB+llFljFJHHx7lZ2kBphgXiJS6tXsYLYvAKuEk2bL4At4xRQl1h6+S8L
	xLIFjBKLmidDXWEjsXrnOmaIBkGJH5PvgS1jBmqYNG8RM4StLfHk3QXWCYwCs5CUzUJSNgtJ
	2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwcnimdQOxpUNFocYBTgYlXh4JfQmhQix
	JpYVV+YeYpTgYFYS4Y3OAQrxpiRWVqUW5ccXleakFh9iNAUGx0RmKdHkfGAiyyuJNzQ2MTOy
	NDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYHTR5Q+/1v++wozFV+vf6coVi9du
	3dkblV0WuDGQR2TKi3UbWxO8tokKReZfjFWbsWddg859qS0/05IbM0M+NN2+8yHC40fF9sWX
	y15+E0/ldZXNP7ye00wsu6Lo8bNJC1TbLW/UrjQ5rhiapqFRtjfiqF4tV76TnMSniLebSlz6
	fdL122VUlViKMxINtZiLihMBunFfnywDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sorry for the late reply.

On Tue, 09 Dec 2014 08:57:17 +0000
Lee Jones <lee.jones@linaro.org> wrote:

> On Mon, 08 Dec 2014, Inha Song wrote:
> 
> > Some boards need to set the OUTn_MONO register to configurates
> > the output signal path as a mono differential output. This
> > wlf,out-mono property is optional. If present, values must be
> > specified less than or equal to the number of output signals.
> > If values less than the number of output signals, elements
> > that has not been specified are set to 0 by default.
> > 
> > Example:
> >  - wlf,out-mono = <1 0 1>; /* set OUT1,OUT3 to mono differential */
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  drivers/mfd/arizona-core.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > index bce7c07..117be32 100644
> > --- a/drivers/mfd/arizona-core.c
> > +++ b/drivers/mfd/arizona-core.c
> > @@ -561,6 +561,16 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
> >  		count++;
> >  	}
> >  
> > +	count = 0;
> > +	of_property_for_each_u32(arizona->dev->of_node, "wlf,out-mono", prop,
> > +				 cur, val) {
> 
> Nit: Can you break after the first parameter instead?
> 
> > +		if (count == ARRAY_SIZE(arizona->pdata.out_mono))
> 
> It's better practise to use ">=".

OK, I will fix this.

Best Regards,
Inha Song.

> 
> > +			break;
> > +
> > +		arizona->pdata.out_mono[count] = !!val;
> > +		count++;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
