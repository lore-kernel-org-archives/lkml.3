Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaK1J5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:57:37 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61874 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaK1J5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:57:34 -0500
Subject: Re: [PATCH 1/1] arcmsr: Notify has sense data report
From: Ching Huang <ching2048@areca.com.tw>
To: Dan Carpenter <dan.carpenter@oracle.com>, hare@suse.de
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20141128091752.GH4911@mwanda>
References: <1417148444.16588.56.camel@Centos6.3-64>
	 <20141128091752.GH4911@mwanda>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Nov 2014 17:57:28 +0800
Message-ID: <1417168648.25477.3.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Dan's advice and Hannes' suggestion.
I will revise and resubmit it later.

On Fri, 2014-11-28 at 12:17 +0300, Dan Carpenter wrote:
> On Fri, Nov 28, 2014 at 12:20:44PM +0800, Ching Huang wrote:
> > This patch is relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr
> > 
> 
> Put this information after the --- cut off line so that it is not
> saved in the permanent git log.
> 
> > Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' if we have sense data.
> > 
> > Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> > ---
> 
> <--- Here.  Put it here.
> 
> > 
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> > --- a/drivers/scsi/arcmsr/arcmsr.h	2014-09-19 11:04:41.845100000 +0800
> > +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-11-28 10:54:30.000000000 +0800
> > @@ -52,7 +52,7 @@ struct device_attribute;
> >  	#define ARCMSR_MAX_FREECCB_NUM	320
> >  #define ARCMSR_MAX_OUTSTANDING_CMD	255
> 
> regards,
> dan carpenter
> 


