Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3D2H4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:56:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62678 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3D2H4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:56:12 -0400
X-AuditID: cbfee691-b7fe56d000004b96-96-517e279a1def
From: Inki Dae <inki.dae@samsung.com>
To: "=?ISO-8859-1?Q?'Uwe_Kleine-K=F6nig'?=" 
	<u.kleine-koenig@pengutronix.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org
References: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
 <20130429073518.GZ15233@pengutronix.de>
In-reply-to: <20130429073518.GZ15233@pengutronix.de>
Subject: RE: [PATCH] module: fix mutiple defined issue
Date: Mon, 29 Apr 2013 16:56:10 +0900
Message-id: <016501ce44af$03129c80$0937d580$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5ErCB2juCxwzCjSW+/mY7NiFuMvwAANpTA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkWHeWel2gwfMvChZXvr5ns2hevJ7N
	YtPja6wWl3fNYbO4PXEyowOrx/65a9g97ncfZ/LYvKTeo/+vgcfnTXIBrFFcNimpOZllqUX6
	dglcGX+nnmYraJKs2P4kuoGxT6SLkZNDQsBEYkvfAVYIW0ziwr31bF2MXBxCAksZJd4tWMAC
	UzT9zh9GiMR0RolvqyZBVf1klFh/9TU7SBWbgKrExBX32UBsEQEviZOLNoN1MAu0Mkq8vDkP
	LCEkkCfRu24DmM0JNHbmxBdMILawgJnEwpWrwOIsQIM+XV7DCGLzCthK/Hi8jgnCFpT4Mfke
	2EnMAjoS+1unsUHY2hJP3l0A+oED6FR1iUd/dSFuMJK4sfUxM0SJiMS+F+/A7pEQuMUuMXv1
	cqhdAhLfJh9igeiVldh0gBniY0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT
	0otM9YoTc4tL89L1kvNzNzEC4/T0v2cTdzDeP2B9iDEZaP1EZinR5HxgnOeVxBsamxlZmJqY
	GhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZG1amqg355GT/uDb70t
	ja88UeA9mZ5yP/nFlNSmfNHdP+++bFDl2XfNfYFb3H1B33vuHwU7fVQerf8ckFS6NbeeQUAn
	Xv388Q+vS5iTn1TcaRR6sLCm44ajdmKCzMwHwvnxevnxu+XDtc/MPi7IoNXDzV7gtKzI9J5c
	7LIXbnx85pGyBjtWKbEUZyQaajEXFScCALNsgR7pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1Z6nWBBruXSVpc+fqezaJ58Xo2
	i02Pr7FaXN41h83i9sTJjA6sHvvnrmH3uN99nMlj85J6j/6/Bh6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGb8nXqaraBJsmL7k+gGxj6RLkZODgkBE4npd/4w
	QthiEhfurWfrYuTiEBKYzijxbdUkKOcno8T6q6/ZQarYBFQlJq64zwZiiwh4SZxctJkRpIhZ
	oJVR4uXNeWAJIYE8id51G8BsTqAVMye+YAKxhQXMJBauXAUWZwEa9OnyGrDVvAK2Ej8er2OC
	sAUlfky+xwJiMwvoSOxvncYGYWtLPHl3gbWLkQPoVHWJR391IW4wkrix9TEzRImIxL4X7xgn
	MArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4CTwTHoH46oG
	i0OMAhyMSjy8AZtrA4VYE8uKK3MPMUpwMCuJ8PZL1QUK8aYkVlalFuXHF5XmpBYfYkwGenQi
	s5Rocj4wQeWVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2OX
	3gd7/kKhx2ebtK3F55977hguVjtt9s/5PrwsHPp5LUuOF87WD9t1v8RgkXai4vLbKf2X9mXF
	vdb6Jvfj2PE5aX1VRw4f1xGb+v/hYZl7EaFbn2Zrt12TLTP97GH9fEf/hhDvpGtra5NaDwoJ
	956KK3breXmZk2F/4ZXFvOwz1j9q//Tg5XIlluKMREMt5qLiRABW+Q7/RgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Uwe Kleine-Konig
> Sent: Monday, April 29, 2013 4:35 PM
> To: Inki Dae
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; dri-
> devel@lists.freedesktop.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] module: fix mutiple defined issue
> 
> On Mon, Apr 29, 2013 at 02:32:01PM +0900, Inki Dae wrote:
> > This patch fixes mutiple defined issue to MODULE_DEVICE_TABLE
> s/mutiple/multiple/, still this sentence doesn't sound right. What is
> the error message you see?
> 
> > The issue could be induced when some framework which includes two
> > more sub drivers, is built as one moudle because those sub drivers
> s/moudle/module/
> 
> > could have their own MODULE_DEVICE_TABLE.
> >
> > And 'struct of_device_id' isn't needed to be determined by type
> > argument because the definition of 'of_device_id' should be fixed.
> > So this patch makes 'of_devce_id' definition to be fixed and
> > only its instance name to be defined by type.
> include/linux/isapnp.h uses:
> #define ISAPNP_CARD_TABLE(name) \
> 		MODULE_GENERIC_TABLE(isapnp_card, name)
> 
> and you changed the table's type with your patch. Ditto for all users of
> 
> 	MODULE_DEVICE_TABLE(i2c, ...);
> 	MODULE_DEVICE_TABLE(acpi, ...);
> 	MODULE_DEVICE_TABLE(platform, ...);
> 	MODULE_DEVICE_TABLE(pci, ...);
> 	MODULE_DEVICE_TABLE(sdio, ...);
> 
> So I'm pretty sure your patch is wrong and I expect it makes most
> defconfigs fail to compile.
>

It might be my big mistake. Maybe xxx_device_id object was created device
tree internally. Right? Will check it out again. So please ignore it.

Thanks,
Inki Dae


> Best regards
> Uwe
> 
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
> > --
> > 1.7.5.4
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
> 
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

