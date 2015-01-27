Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbbA0KSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:18:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589AbbA0KSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:18:01 -0500
Date: Tue, 27 Jan 2015 13:17:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        thomas@grouk.net, tapaswenipathak@gmail.com,
        gregkh@linuxfoundation.org, rickard_strandqvist@spectrumdigital.se,
        linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2] staging: rtl8712: fix Prefer [subsystem eg:
 netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to
 printk(KERN_INFO ...
Message-ID: <20150127101719.GS6456@mwanda>
References: <20150126125229.GA11609@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126125229.GA11609@mohammed-Inspiron-3537>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The subject line is too long.

> -	printk(KERN_INFO "r8712u: Staging version\n");
> +	pr_info("r8712u: Staging version\n");

This is a dumb thing to print.  Just delete this line.

regards,
dan carpenter

