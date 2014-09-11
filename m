Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaIKQw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:52:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24150 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaIKQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:52:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-de-5411d3640073
Content-transfer-encoding: 8BIT
Message-id: <1410454368.8852.13.camel@AMDC723>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct
 generic_pm_domain-s
From: Maciej Matraszek <m.matraszek@samsung.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 11 Sep 2014 18:52:48 +0200
In-reply-to: <20140910191825.GA7996@ZenIV.linux.org.uk>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
 <20140910191825.GA7996@ZenIV.linux.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7oplwVDDHoWcVlsnLGe1aJ58Xo2
	i9cvDC1mTdnLZHF51xw2i8+9Rxgt7p46ymZx5vQlVovzf4+zOnB6LN7zkslj/9w17B5brraz
	ePRtWcXosWL1d3aPz5vkPDY9ecsUwB7FZZOSmpNZllqkb5fAlbFk2juWgj0sFSum32VtYDzC
	3MXIySEhYCLRuOgRI4QtJnHh3nq2LkYuDiGBpYwSB9buYgdJ8AoISvyYfI+li5GDg1lAXuLI
	pWyQMLOAusSkeYuYIeo/M0p8f3OGBaJeT+L09glgvcICYRJ/+jezgthsAgYSm//1g9WICKhK
	3Dl1hgli0H4miRUHzEDmswDFX/abgIQ5BcwlplxrYgOxhQRKJNbNus4OUiIhoCzR2O82gVFg
	FpLjZiEcNwvJcQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETB1x2MS49ZHWIU4GBU
	4uH9kCsYIsSaWFZcmXuIUYKDWUmE13khUIg3JbGyKrUoP76oNCe1+BAjEwenVAPjhmn9mapc
	rnEz05UlQnY0vHOKPrZ5p/LObS/a2QRfX2UoqTwx28/kWnHSvkZXX4+OsytVot8ZKMTy85pz
	SfEsjk1a/zv2wtOEF55uB0S1drbvO2SQwGqjf/tw9Zok2X8Kf6q/Jm1MDzcoPHHZ4snz6SEG
	EWJHjwf+DxU8yjjhzymNedOdq4WUWIozEg21mIuKEwEG3VQ6YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al!

On śro, 2014-09-10 at 20:18 +0100, Al Viro wrote:
> On Wed, Sep 10, 2014 at 01:28:56PM +0200, Maciej Matraszek wrote:
> 
> > +static int pm_genpd_summary_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, pm_genpd_summary_show, inode->i_private);
> 							^^^^^^^^^^^^^^^^
> 							what for?
> 
> Where in pm_genpd_summary_show() are you using ->private?

Nowhere, thanks! (Just a mindless copy-paste from clk_summary_open().)

Regards,
-- 
Maciej Matraszek
Samsung R&D Institute Poland
Samsung Electronics


