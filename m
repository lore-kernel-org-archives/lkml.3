Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaHYJUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:20:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56929 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaHYJUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:20:04 -0400
X-AuditID: cbfee68e-f79536d000000fd1-25-53faffc2b0e9
Date: Mon, 25 Aug 2014 18:20:01 +0900
From: Inha Song <ideal.song@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, sameo@linux.intel.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, patches@opensource.wolfsonmicro.com,
        lgirdwood@gmail.com, robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        cw00.choi@samsung.com, broonie@kernel.org, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH v2 1/2] mfd: arizona: Add support for INn_Mode
 register control
Message-id: <20140825182001.666bd966@songinha-Samsung-DeskTop-System>
In-reply-to: <20140821121219.GF4266@lee--X1>
References: <20140813205313.65bbe343@songinha-Samsung-DeskTop-System>
 <20140821121219.GF4266@lee--X1>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsWyRsSkRPfQ/1/BBkdX6lhcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktTj3aiWjxf2vRxktvl3pYLK4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	mHcy0OPlxN9sHn1bVjF6fN4kF8AdxWWTkpqTWZZapG+XwJWxdvYlxoLjQhXfzrcxNjDe5uti
	5OCQEDCR+LNFsouRE8gUk7hwbz1bFyMXh5DAUkaJu+uOMUIkTCROzJvBDGILCUxnlJg30xnC
	7meS+LtaG8RmEVCVaD4wHayeTUBD4vvnzcwg80UEVCTOvTEHmcks8J1J4tSP32A1wgJJEvtv
	zmYHsXkFXCVWvmgBszkFdCRmPznJDtIrJJAuceqsNMQJNhKrd65jhigXlPgx+R4LiM0soC4x
	ad4iZghbW+LJuwusILskBNZySFzbt5UF4jYBiW+TD7FA/CsrsekAM8RMSYmDK26wTGAUm4Vk
	7CwkY2chGbuAkXkVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmDkn/73rG8H480D1ocYBTgY
	lXh4V3D+ChZiTSwrrsw9xGgKdMVEZinR5HxgeskriTc0NjOyMDUxNTYytzRTEudNkPoZDPRv
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZQ2Ukci84EbdmVvdTW+O+LtweS/z0tW9Fw4rnpw6sT
	3Sd9Cp5yYrJwMYtvzZTO0Purjqmtl55ePk+pxEjD8Aw/++TcR73J5e0PnzUKdcctCKjhuXRZ
	+NVqjkemu3+sOL1vbY5ckYhzMidPXJBO+Zam/nOna8r6ty6bWLrl1rsnU/23nMrKZ9ykxFKc
	kWioxVxUnAgAFSvep/cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd1D/38FG2y7o2Rx5eIhJoupD5+w
	WfybcoPd4vqX56wW84+cY7Xof7OQ1eLcq5WMFve/HmW0+Halg8ni8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	Y97JQI+XE3+zefRtWcXo8XmTXAB3VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjLWzLzEWHBeq+Ha+jbGB8TZfFyMnh4SAicSJeTOYIWwxiQv31rOB2EIC0xkl5s10hrD7
	mST+rtYGsVkEVCWaD0xnBLHZBDQkvn/eDNTLwSEioCJx7o15FyMXB7PAdyaJUz9+g9UICyRJ
	7L85mx3E5hVwlVj5ogXM5hTQkZj95CQ7SK+QQLrEqbPSECfYSKzeuY4ZolxQ4sfkeywgNrOA
	usSkeYuYIWxtiSfvLrBOYBSYhaRsFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P
	3cQITizPpHcwrmqwOMQowMGoxMO7kvNXsBBrYllxZe4hRgkOZiURXo0/QCHelMTKqtSi/Pii
	0pzU4kOMpsDAmMgsJZqcD0x6eSXxhsYmZkaWRuaGFkbG5krivAdbrQOBXkssSc1OTS1ILYLp
	Y+LglGpgrJsy4e/U3gPqYTdfrlhk0XqyQemMqrSQwHm5p53Tl390//nwgON++WgnRvvAn2m7
	3h4NyG/J8dxmqs269tXCgk9bPvDNXbv5c/f02w9TTOP1b1wN14kOcLPvCrG10JTbVL3qO/Nf
	++vrdx6p2Su5+p/WB7OgVRkvFsdJJ099oPk7YLJ5mHLwDCWW4oxEQy3mouJEAJ8QtaBCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, 21 Aug 2014 13:12:19 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> On Wed, 13 Aug 2014, Inha Song wrote:
> 
> > Some boards need to set the INn_MODE[1:0] register to change
> > the input signal patch. This wlf,inmode property is optional.
> > If present values must be specified by the number of
> > ARIZONA_MAX_INPUT.
> > 
> > Example:
> >    - wlf,inmode = <2 0 2 0>;	/* IN1, IN3 use DMIC */
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  drivers/mfd/arizona-core.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> This is going to require a DT Ack.
> 
> Is [2/2] adding the documentation?  I can't easily go and look because
> you send the patch-set unthreaded.  Please thread patch-sets.  See
> the man page for `git send-email` for more information.
> 

Sorry, I will resend this patch set to use "git send email".

Best regards,
Inha Song.

> > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > index 10a0cb9..2b68ccd 100644
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
> > @@ -560,6 +560,15 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
> >  			ret);
> >  	}
> >  
> > +	proplen = of_property_count_u32_elems(arizona->dev->of_node,
> > +					      "wlf,inmode");
> > +	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode)) {
> > +		for (i = 0; i < proplen; i++)
> > +			of_property_read_u32_index(arizona->dev->of_node,
> > +						   "wlf,inmode", i,
> > +						    &arizona->pdata.inmode[i]);
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
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
