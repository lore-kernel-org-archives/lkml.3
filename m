Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaH2Imm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:42:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54797 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaH2Imh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:42:37 -0400
X-AuditID: cbfee68f-f797f6d000001173-cc-54003cf47e80
Date: Fri, 29 Aug 2014 17:42:27 +0900
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
Message-id: <20140829174227.4734992c@songinha-Samsung-DeskTop-System>
In-reply-to: <20140829081741.GD24579@lee--X1>
References: <20140818200003.2ab8aca0@songinha-Samsung-DeskTop-System>
 <20140828113651.GN24579@lee--X1>
 <20140829170230.673ca9ff@songinha-Samsung-DeskTop-System>
 <20140829081741.GD24579@lee--X1>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsWyRsSkWPeLDUOIwe8OWYsrFw8xWUx9+ITN
	4t+UG+wW1788Z7WYf+Qcq0X/m4WsFuderWS0uP/1KKPFtysdTBaXd81hs1h6/SKTxfK3/9ks
	Jkxfy2LRuvcIu8XpblYHfo8Nn5vYPNbMW8Pocbmvl8lj56y77B4rl39h89i0qpPN4861PWwe
	804Geryc+JvNo2/LKkaPz5vkArijuGxSUnMyy1KL9O0SuDL2nT/CVPBZsOLjqVtsDYwPebsY
	OTkkBEwkPi/+xgZhi0lcuLceyObiEBJYyiix9dgm5i5GDrCiuevMIOLTGSWWnn8LVdTPJPHu
	9Gt2kG4WAVWJm8/uM4PYbAIaEt8/bwZrFhFQkTj3xhyknlngO5NE/8lHYHFhgWSJk1dZQcp5
	BVwlLs1oZwSxOQV0JTbO/Qs1/zijxNkJc5ggrrORWL1zHTNEg6DEj8n3WEBsZgEtic3bmlgh
	bHmJzWveMoM0Swjs4JD4+r2DEeI4AYlvkw+xQHwjK7HpADPETEmJgytusExgFJuFZOwsJGNn
	IRm7gJF5FaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZg/J/+96x/B+PdA9aHGAU4GJV4eDtO
	/g8WYk0sK67MPcRoCnTFRGYp0eR8YJLJK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo+0W+c9nshWyvfKfNQu1/s77xGA08UxN5QVDX0sp3/db1PKy
	rx1lnnn7oYFNxGOlfV8EtKTcFy9xeWr0+Pf+pIAC7bgaVsPs4shDtloMIuvP1ItaJcyXXX15
	0UI/qUvL5gg+s91yIXTWBu89SyWOVsaW3L6yTn/evH9VwqISbK1PTlVGxr6qVmIpzkg01GIu
	Kk4EANtXJpn6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd0vNgwhBn3zRCyuXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOYse/8EaaCz4IVH0/dYmtgfMjbxcjBISFgIjF3nVkXIyeQKSZx4d56ti5GLg4hgemMEkvP
	v4Vy+pkk3p1+zQ5SxSKgKnHz2X1mEJtNQEPi++fNzCCDRARUJM69MQepZxb4ziTRf/IRWFxY
	IFni5FVWkHJeAVeJSzPaGUFsTgFdiY1z/0LNP84ocXbCHCaIK2wkVu9cxwzRICjxY/I9FhCb
	WUBLYvO2JlYIW15i85q3zBMYBWYhKZuFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS
	83M3MYKTyzOpHYwrGywOMQpwMCrx8Hac/B8sxJpYVlyZe4hRgoNZSYT3uCFDiBBvSmJlVWpR
	fnxRaU5q8SFGU2BoTGSWEk3OBya+vJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakF
	qUUwfUwcnFINjAv+zP2ZNbvo1qOnBkY3Lx3qXfTtUd8U06jPJ2ymN8ziVkndd/bclkSmlZZn
	5Q76bXvBlmQfKbdS3/IG1/m0Zj2ndadjUh5ETBaffGjvvSU2f11TG2fNjF3uyPuqX11T1vep
	/eRjFgyvK7+usqiLmc03+d/OA7W3my6qud9hKjkU+6Pz86w4nT1KLMUZiYZazEXFiQAlm29q
	RAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014 09:17:41 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> On Fri, 29 Aug 2014, Inha Song wrote:
> 
> > Hi, Lee
> > Thanks for your review.
> > 
> > On Thu, 28 Aug 2014 12:36:51 +0100
> > Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > On Mon, 18 Aug 2014, Inha Song wrote:
> > > 
> > > > Some boards need to set the INn_MODE[1:0] register to change
> > > > the input signal patch. This wlf,inmode property is optional.
> > > > If present, values must be specified less than or equal to
> > > > the number of input singals. If values less than the number
> > > > of input signals, elements that has not been specifed are set
> > > > to 0 by default.
> > > > 
> > > > Example:
> > > >    - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */
> > > > 
> > > > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > > > ---
> > > >  drivers/mfd/arizona-core.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > > > index 10a0cb9..81e6db8 100644
> > > > --- a/drivers/mfd/arizona-core.c
> > > > +++ b/drivers/mfd/arizona-core.c
> > > > @@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
> > > >  static int arizona_of_get_core_pdata(struct arizona *arizona)
> > > >  {
> > > >  	struct arizona_pdata *pdata = &arizona->pdata;
> > > > -	int ret, i;
> > > > +	int ret, i, proplen;
> > > >  
> > > >  	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
> > > >  
> > > > @@ -560,6 +560,12 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
> > > >  			ret);
> > > >  	}
> > > >  
> > > > +	proplen = of_property_count_u32_elems(arizona->dev->of_node,
> > > > +					      "wlf,inmode");
> > > > +	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode))
> > > > +		of_property_read_u32_array(arizona->dev->of_node, "wlf,inmode",
> > > > +					   arizona->pdata.inmode, proplen);
> > > 
> > > of_property_for_each_u32()?
> > 
> > Is it more clear to use of_property_for_each_u32() instead of
> > of_property_read_u32_array()?
> 
> It prevents you from having to use of_property_count_u32_elems() first.

OK, I will fix this. Thanks.

Best regards,
Inha Song.
