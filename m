Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab3BTIRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:17:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64523 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597Ab3BTIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:17:38 -0500
X-AuditID: cbfee68e-b7fc26d000001938-0f-5124869a8d98
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002c01ce0f31$48d55e00$da801a00$%han@samsung.com>
 <20130220073044.GB2648@core.coreip.homeip.net>
 <000801ce0f41$00e79170$02b6b450$%han@samsung.com>
 <20130220081014.GA4268@core.coreip.homeip.net>
In-reply-to: <20130220081014.GA4268@core.coreip.homeip.net>
Subject: Re: [PATCH 07/11] mfd: menelaus: use devm_request_irq() and
 devm_kzalloc()
Date: Wed, 20 Feb 2013 17:17:30 +0900
Message-id: <000d01ce0f42$ba3a1570$2eae4050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PQbjq5ZYTDbwYQWe0376wt+cLzQAAMQEg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ91ZbSqBBt+OWFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9kfTmApOcldcvr6PvYHxGUcXIyeHhICJxN8HE1ggbDGJC/fW
	s3UxcnEICSxjlPj4/xQzTNHVBc1gRUIC0xklHjabQBTNZpI48nUiG0iCTUBN4suXw+xdjBwc
	IgKGEjPWVIGEmQXyJL4taoIa2s4k8aV/JztIglPAWmLV335WEFtYIFRiwub3YHEWAVWJXyv/
	gi3mFbCVOHH7ACOELSjxY/I9FoihWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHE8vtb
	oMpFJPa9eMcI8csydokF0xIgVglIfJt8iAWiVVZi0wGodyUlDq64wTKBUWIWksWzkCyehWTx
	LCQbFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIiau+HYw3D1gfYkwGWj+RWUo0OR8Y
	l3kl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwChQ
	tnbJ/sy0g2+ndgadPOG/Y988wSihB5+Vi3gyo46u92FKqX5lsttbj+vK+lfhX9/NtfqcFPWw
	9I4kr8KUqNMMrDefV278fdm5SEaUa5Oq5s8W9WMbZ86+OeNoyNXZklI79miePnM6Yp3pV/NT
	QU0TExh7VWrbTcuk+6Ytf7lJ0vKWiQmH2GklluKMREMt5qLiRAC5bO3swQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoO6sNpVAg7195haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo/3RNKaCk9wVl6/vY29g
	fMbRxcjJISFgInF1QTMLhC0mceHeejYQW0hgOqPEw2aTLkYuIHs2k8SRrxPBEmwCahJfvhxm
	72Lk4BARMJSYsaYKJMwskCfxbVETG0R9O5PEl/6d7CAJTgFriVV/+1lBbGGBUIkJm9+DxVkE
	VCV+rfzLDGLzCthKnLh9gBHCFpT4MfkeC8RQLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhE
	wEhi+f0tUOUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxguP2mfQOxlUNFocYBTgYlXh4GxYqBwqxJpYVV+YeYpTgYFYS4W12UgkU4k1JrKxK
	LcqPLyrNSS0+xJgM9OhEZinR5HxgSskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU
	7NTUgtQimC1MHJxSDYyiTR8n77nnION+LSMmbl1swGPnWU961Rhc+/6zLPD7pvs0zPiZyknR
	ZNv3Jz6s/t1wd+/Uql+5jfNK0vRm2Nke5Sj4ZPI2sHc9wwFn5jCuksUPeJJvc08p17r/9Vr4
	6pPa3bI3V4btvGaQKF1/yzHKR+fIKlumntXMmf2i2h98JBxqbfqjviqxFGckGmoxFxUnAgCa
	YyGVHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 5:10 PM, Dmitry Torokhov wrote:
> 
> On Wed, Feb 20, 2013 at 05:05:10PM +0900, Jingoo Han wrote:
> > On Wednesday, February 20, 2013 4:31 PM, Dmitry Torokhov wrote:
> > >
> > > Hi Jongoo,
> > >
> > > On Wed, Feb 20, 2013 at 03:12:38PM +0900, Jingoo Han wrote:
> > > > Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> > > > more simple.
> > > >
> > >
> > > ...
> > >
> > > > @@ -1269,9 +1266,7 @@ static int __exit menelaus_remove(struct i2c_client *client)
> > > >  {
> > > >  	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
> > > >
> > > > -	free_irq(client->irq, menelaus);
> > > >  	flush_work(&menelaus->work);
> > > > -	kfree(menelaus);
> > > >  	the_menelaus = NULL;
> > > >  	return 0;
> > >
> > > This conversion is certainly wrong - you really want to disable IRQ and
> > > then wait for the scheduled work to finish before freeing memory. Here
> > > you flush work but nothing stops IRQ from firing and scheduling that
> > > work again.
> >
> > Yes, you're right.
> > I will use devm_free_irq() before flush_work().
> 
> Why change it at all if you have to call it manually in both error
> unwinding and menelaus_remove() cases?
> 
> BTW, that __exit markup on menelaus_remove() is surprising... I am
> pretty sure it can be unbound via sysfs and so there will be a nasty
> oops.

I see, I will not modify this menelaus mfd driver.
Thank you.

> 
> --
> Dmitry

