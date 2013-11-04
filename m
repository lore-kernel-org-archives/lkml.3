Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3KDQrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:47:19 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50085 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3KDQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:47:18 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <5271D340.2090706@gmail.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <5271D340.2090706@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:45:57 +0100
Message-ID: <1383583557.15642.32.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-3548-0000-0000-0000070AC6AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Am Donnerstag, den 31.10.2013, 14:49 +1100 schrieb Ryan Mallon:
> > +/**
> > + * create_card_sysfs() - Setup sysfs entries of the card device
> > + *
> > + * VFs have restricted mmio capabilities, so not all sysfs entries
> > + * are allowed in VFs.
> > + */
> > +int create_card_sysfs(struct genwqe_dev *cd)
> 
> This is extern, and has a very generic name. Prefix it with genwqe or
> something. Same for the function below, and for any other extern
> symbols
> you have.

Good finding. I fixed that in the course of the other sysfs reworks too.
Thanks for pointing it out.

Regards

Frank

