Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3CFGMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:12:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:57458 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3CFGMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:12:45 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-7d-5136de5ca07f
Date: Wed, 06 Mar 2013 06:12:44 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Tejun Heo'" <tj@kernel.org>, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130306061139487@jg1.han
Msgkey: 20130306061139487@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130306061139487@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12429277.417351362550362880.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsVy+t8zQ92Ye2aBBrd7WC0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmvHi+nqlgB3/F/dWVDYwN/F2MnBxCAkoSk07uZQSxJQRMJFZM7mKB
	sMUkLtxbz9bFyAVUs4xR4nVjKzNM0ZwH/SwQifmMEjMunAVKcHCwCKhI/Go2BKlhE1CXmPC7
	GWyQsICHxMFzHWALRAT0JBa9PAXWyyxwlEmif14rE8QVshL3Js8GW8ArIChxcuYTFpCZEgIK
	Eh+fcEOEFSXeXNzJBnGDhMSd+/tZIWxeiRntT6GOlpOY9nUN1J3SEudnbWCEeWbx98dQcX6J
	Y7d3MEGM55V4cj8YZszuzV+gxgtITD1zkBGiRFXi/8MgiDCfxJqFb6E2CUqcvtbNDNPasPE3
	O4jNDHTllO6HULaWxJcf+9hQPQViO0l0da9imsCoPAtJahaS9llI2pHVLGBkWcUomlqQXFCc
	lF5khBzVmxghKbBvB+PNA9aHGPczAmNkIrOUaHI+MInmlcQbGhubmJmYmphbmpqbUiBsbmRq
	AEynBobUEVYS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTGjoeKLa/jDqv/enexM
	q5gE3hyt9jVb68S/7LmeV6miVtLum30sAfc+KxnvvvboRGXGkeW7mDbPSdhqoyAomcETtvLg
	ZtGzMyIVL7mcmnP8+ly1MPeAIwoNN9exqqdl/rK4dvfDmkauyddDnQs1Y4WEdQ7dsFA6oO16
	aM73gvkmj3b4yHN+ZlJiKc5INNRiLipOBACr/6qW9AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tGbox98wCDRZOY7S4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GS+er2cq2MFfcX91ZQNjA38XIyeHkICSxKSTexlBbAkBE4k5D/pZIGwxiQv31rN1MXIB1cxn
	lJhx4SxzFyMHB4uAisSvZkOQGjYBdYkJv5vB6oUFPCQOnusAmyMioCex6OUpFpBeZoGjTBL9
	81qZIJbJStybPJsZxOYVEJQ4OfMJC8hMCQEFiY9PuCHCihJvLu5kg7hBQuLO/f2sEDavxIz2
	p1C3yUlM+7qGGcKWljg/awMjzM2Lvz+GivNLHLu9gwliPK/Ek/vBMGN2b/4CNV5AYuqZg4wQ
	JaoS/x8GQYT5JNYsfAu1SVDi9LVuZpjWho2/2UFsZqArp3Q/hLK1JL782MeG6ikQ20miq3sV
	0wRGuVlIUrOQtM9C0o6sZgEjyypG0dSC5ILipPQKQ73ixNzi0rx0veT83E2M4OT0bOEOxi/n
	rQ8xCnAwKvHwWiiZBQqxJpYVV+YeYpTgYFYS4eU6AxTiTUmsrEotyo8vKs1JLT7EmAyMvonM
	UqLJ+cDEmVcSb2hsbGJmYmpuYGFgaU6asJI473Fz9UAhgfTEktTs1NSC1CKYLUwcnFINjAwh
	XqcXn0mZpHSCwfyKypUXe5/+z5NJuLXA/7R2zdSN9YYrYjalOK8PXJ+yYtr1q3+tlm4VC9a8
	NP+Mecfi3qS3C+pWVqzpbtzWel3r6Xv+rb/OnN2/9aj0wcB/1/5fn3vXQvCq+TrXxJXaf+91
	zlZbdHJt24bFmhlx75ZnRmReYDq3aK9ji3iTEktxRqKhFnNRcSIALJ6EI5IDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r266Cr6m011782

On Wednesday, March 06, 2013 3:03 PM, Venu Byravarasu wrote:
> 
> > --- a/drivers/rtc/class.c
> > +++ b/drivers/rtc/class.c
> 
> > +/**
> > + * devm_rtc_device_register - resource managed rtc_device_register()
> > + * @name: the name of the device
> > + * @dev: the device to register
> > + * @ops: the rtc operations structure
> > + * @owner: the module owner
> > + *
> > + * @return a struct rtc on success, or an ERR_PTR on error
> > + *
> > + * Managed rtc_device_register(). The rtc_device returned from this
> > function
> > + * are automatically freed on driver detach. See rtc_device_register()
> > + * for more information.
> > + */
> > +
> > +struct rtc_device *devm_rtc_device_register(const char *name,
> > +					struct device *dev,
> 
> As most of devm_* functions use  " struct device *dev" as their first param,
> why not this function also modified to be in sync with them?

Yes, but, I want to sync with the form of rtc_device_register().
This function already uses 'struct device *dev' as second argument as below.

 struct rtc_device *rtc_device_register(const char *name, struct device *dev,
                                         const struct rtc_class_ops *ops,
                                         struct module *owner)

Best regards,
Jingoo Han

> 
> > +					const struct rtc_class_ops *ops,
> > +					struct module *owner)
> > +{
> > +	struct rtc_device **ptr, *rtc;
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
