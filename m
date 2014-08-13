Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaHMA0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:26:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37711 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaHMA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:26:18 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-2f-53eab0a3117f
Date: Wed, 13 Aug 2014 09:26:09 +0900
From: Inha Song <ideal.song@samsung.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, sameo@linux.intel.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        cw00.choi@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        lee.jones@linaro.org
Subject: Re: [alsa-devel] [PATCH 1/2] mfd: arizona: Add support for	INn_MODE
 register control
Message-id: <20140813092609.35a98034@songinha-Samsung-DeskTop-System>
In-reply-to: <20140812082811.GB15833@opensource.wolfsonmicro.com>
References: <20140809173138.767b97fd@songinha-Samsung-DeskTop-System>
 <20140812082811.GB15833@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42JZI2JSort4w6tgg2k35S2uXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4MpY8/MMY0Ejd8XSDv0GxhscXYyc
	HBICJhIt8xcxQdhiEhfurWfrYuTiEBJYyihxYuJJdpiiV4uXsoHYQgKLGCU63mlDFPUzSfxe
	184KkmARUJVoaZoNVsQmoCHx/fNmZhBbRMBCYsqSW8wgDcwCz5gkTkx+zQKSEBaIl/jVeZgR
	xOYVcJU4c/8aWAOngKPEsRdHgeIcQBtqJP4/rIc4wkZi9c51zBDlghI/Jt8DG8MsoCWxeVsT
	K4QtL7F5zVuwXRICazkkXk15zwxxnIDEt8mHWEBmSgjISmw6wAwxU1Li4IobLBMYxWYhGTsL
	ydhZSMYuYGRexSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREY/af/PevfwXj3gPUhxmSglROZ
	pUST84HJI68k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MMolqLTeSd27sfJY4CLJyH2/bvbV7z9mWTyfSctkz9Qki/P/ns2Y5j512/lpQrzO8eYN
	DY+Fci69f339eIye1LK1/tqifj9LkmoPTdTjW6DTkpkUtfuFRFdfgBj7+iLNbTfvRYjb/rIQ
	r23kKdAy25B9sH6WffhrxneSWxgLD+u4uv2f26f6UomlOCPRUIu5qDgRAP41tkYUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd3FG14FG2y9J25x5eIhJoupD5+w
	WfybcoPd4vqX56wW84+cY7Xof7OQ1eLcq5WMFve/HmW0+Halg8ni8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	Y97JQI+XE3+zefRtWcXo8XmTXAB3VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjDU/zzAWNHJXLO3Qb2C8wdHFyMkhIWAi8WrxUjYIW0ziwr31YLaQwCJGiY532l2MXEB2
	P5PE73XtrCAJFgFViZam2WBFbAIaEt8/b2YGsUUELCSmLLnFDNLALPCMSeLE5NcsIAlhgXiJ
	X52HGUFsXgFXiTP3r4E1cAo4Shx7cRQozgG0oUbi/8N6iCNsJFbvXMcMUS4o8WPyPbAxzAJa
	Epu3NbFC2PISm9e8ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7
	iRGcWp5J72Bc1WBxiFGAg1GJh3eH66tgIdbEsuLK3EOMEhzMSiK85V1AId6UxMqq1KL8+KLS
	nNTiQ4ymwNCYyCwlmpwPTHt5JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6
	mDg4pRoYI6eevGbiKLfEqzakeF3+kX0xy8+EFipPr1Hea8bHHDh/XlDEpluv7tUfTL4l85KR
	5f6pqobVy8v6LF4JfEmcsHmvVPstJfWmwkL9J085L3yfX15nd/Ouj4XjaqnyBxyr7i5dtuLB
	lguTG6bds9w8ZV7H9MsVPq9TeN0muau9Pi18gNfJ1P/TAyWW4oxEQy3mouJEAP2qyupDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Charles.

Thanks for your review.

On Tue, 12 Aug 2014 09:28:11 +0100
Charles Keepax <ckeepax@opensource.wolfsonmicro.com> wrote:

> On Sat, Aug 09, 2014 at 05:31:38PM +0900, Inha Song wrote:
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
> >  drivers/mfd/arizona-core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > index 10a0cb9..4b2eb73 100644
> > --- a/drivers/mfd/arizona-core.c
> > +++ b/drivers/mfd/arizona-core.c
> > @@ -560,6 +560,10 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
> >  			ret);
> >  	}
> >  
> > +	of_property_read_u32_array(arizona->dev->of_node,
> > +					 "wlf,inmode",
> > +					 arizona->pdata.inmode,
> > +					 ARRAY_SIZE(arizona->pdata.inmode));
> 
> Might be better to allow the device tree to be shorter than the
> array in pdata, should this get expanded on future devices.
> 

OK, I will fix in v2 to use "of_property_count_u32_elems" and "of_property_read_u32_index".

Best regards,
Inha Song.

> Thanks,
> Charles
