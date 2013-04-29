Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3D2KG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:06:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11514 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab3D2KGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:06:25 -0400
X-AuditID: cbfee68f-b7f066d000003683-4d-517e461f2130
From: Inki Dae <inki.dae@samsung.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org
References: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
 <20130429095138.GJ14496@n2100.arm.linux.org.uk>
In-reply-to: <20130429095138.GJ14496@n2100.arm.linux.org.uk>
Subject: RE: [PATCH] module: fix mutiple defined issue
Date: Mon, 29 Apr 2013 19:06:23 +0900
Message-id: <019801ce44c1$34326d60$9c974820$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5EvzF8LcV/8l/FTj2OPklnir6slwAAQk7A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkWFferS7QYF6HjcWVr+/ZLJoXr2ez
	2PT4GqvF5V1z2CxuX+Z1YPVoae5h89g/dw27x/3u40wem5fUe3zeJBfAGsVlk5Kak1mWWqRv
	l8CVcaP1L1vBC+GK9nU/2BsYpwt0MXJwSAiYSNz8ZNPFyAlkiklcuLeeDcQWEljKKLF1YyhM
	SfNC2y5GLqDwdEaJA5uaWSCcn4wSj06tAWtgE1CVmLjiPpgtImAuMW/mJCaQImaBVkaJlzfn
	sYFMEhIokzi1tBSkhlPARuL+99ksILawgJnEwpWrwHpZgOb8+tTCCmLzCthKTGj7wwhhC0r8
	mHwPrJ5ZQEti/c7jTBC2vMTmNW+ZIQ5Vl3j0VxfiBCOJB1Mns0OUiEjse/GOEeQcCYFb7BKf
	PzdD7RKQ+Db5EAtEr6zEpgPMkHCQlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmg
	OCm9yFivODG3uDQvXS85P3cTIzBCT/971r+D8e4B60OMyUDrJzJLiSbnAyM8ryTe0NjMyMLU
	xNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MsR8FGl7si/ddfuDs
	E7e6vbkyz3Wf2lZvPxa7l1/gj7/jrlhv/72Cfnceqf/Ov/a2R8XwxLqZO6a5nNl8I+Ux9/6b
	Pqk7LMqkUm1P+xh/NTeo4T60ftNqpZ5PcZa61y7LfZZ4WLLt4vKZ63lbyhtfXAwv/GO4fXmg
	wW5r/q3Hjf6JLUw/VbtBQImlOCPRUIu5qDgRAEpnTRPmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV15t7pAg0s9phZXvr5ns2hevJ7N
	YtPja6wWl3fNYbO4fZnXgdWjpbmHzWP/3DXsHve7jzN5bF5S7/F5k1wAa1QDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0G4lhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aN1r9sBS+EK9rX/WBvYJwu0MXIwSEhYCLRvNC2
	i5ETyBSTuHBvPVsXIxeHkMB0RokDm5pZIJyfjBKPTq1hA6liE1CVmLjiPpgtImAuMW/mJCaQ
	ImaBVkaJlzfnsYFMFRIokzi1tBSkhlPARuL+99ksILawgJnEwpWrwHpZgOb8+tTCCmLzCthK
	TGj7wwhhC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW+ZIY5Wl3j0VxfiBCOJB1Mns0OUiEjse/GO
	cQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOAc+kdzCu
	arA4xCjAwajEwxuwuTZQiDWxrLgy9xCjBAezkgjvGce6QCHelMTKqtSi/Pii0pzU4kOMyUCP
	TmSWEk3OB6anvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	rHDPbtX3/tj7d9f8v8+jVPmmvrMSW5Syxc/H/1kzk3vmz07pZL9JDeHebUEWL37lnThkmDyr
	eN7qR3zLugyf8hYzbuQ8d3W5flxguqymV49quoiSqf5C3qKQ88EvpxTONg14xv3U6soyrXfB
	ZseTcmrtC46e1LHd94vp5pP1S5k1uX9ncRgpsRRnJBpqMRcVJwIAQVvwIEUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Russell King - ARM Linux
> Sent: Monday, April 29, 2013 6:52 PM
> To: Inki Dae
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; dri-
> devel@lists.freedesktop.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] module: fix mutiple defined issue
> 
> On Mon, Apr 29, 2013 at 02:32:01PM +0900, Inki Dae wrote:
> > This patch fixes mutiple defined issue to MODULE_DEVICE_TABLE
> >
> > The issue could be induced when some framework which includes two
> > more sub drivers, is built as one moudle because those sub drivers
> > could have their own MODULE_DEVICE_TABLE.
> >
> > And 'struct of_device_id' isn't needed to be determined by type
> > argument because the definition of 'of_device_id' should be fixed.
> > So this patch makes 'of_devce_id' definition to be fixed and
> > only its instance name to be defined by type.
> >
> > Signed-off-by: Inki Dae <inki.dae@samsung.com>
> > ---
> >  include/linux/module.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 46f1ea0..ac5d79f 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -84,7 +84,7 @@ void trim_init_extable(struct module *m);
> >
> >  #ifdef MODULE
> >  #define MODULE_GENERIC_TABLE(gtype,name)			\
> > -extern const struct gtype##_id __mod_##gtype##_table		\
> > +extern const struct of_device_id __mod_##gtype##_table		\
> >    __attribute__ ((unused, alias(__stringify(name))))
> >
> >  #else  /* !MODULE */
> 
> This patch (a) looks wrong (why would a generic device table be limited
> to of_device_id when it could be ISAPNP or something else?) and (b) how
> does changing the type fix the "multiple defined issue" ?  (c) include
> the errors that you're fixing in the commit log.

There was my misunderstanding. So please ignore my patch. Some headers in
include/linux/ have some kind of device_id structure such as of_device_id,
platform_device_id, i2c_device_id, and so on. And these structures should be
used properly. This was my missing point.

Thanks,
Inki Dae


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

