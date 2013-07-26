Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab3GZMVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:21:02 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:51166 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:20:59 -0400
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Michal Marek <mmarek@suse.cz>
Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <51F12668.8000400@suse.cz>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
	 <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
	 <51F12668.8000400@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 26 Jul 2013 14:20:52 +0200
Message-ID: <1374841252.11182.13.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072612-6892-0000-0000-000005CEBF75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Am Donnerstag, den 25.07.2013, 15:21 +0200 schrieb Michal Marek:
> On 25.7.2013 10:28, Frank Haverkamp wrote:
> > +	dev_info(&pci_dev->dev, "GenWQE driver version: %s (build %s) %s%u\n",
> > +		 DRV_VERS_STRING, __DATE__, GENWQE_DEVNAME, cd->card_idx);
> [...]
> > +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> > +			 "GenWQE driver version: %s (build %s)\n"
> > +			 "    Device Name/Type: %s %s CardIdx: %d\n"
> > +			 "    SLU/APP Config  : 0x%016llx/0x%016llx\n"
> > +			 "    Build Date/Type : %u/%x/%u %s\n"
> > +			 "    Base Clock      : %u MHz\n"
> > +			 "    Arch/SVN Release: %u/%llx\n"
> > +			 "    Bitstream       : %llx\n",
> > +			 DRV_VERS_STRING, __DATE__, dev_name(&pci_dev->dev),
> 
> Please remove the __DATE__ macros, so that the generated object code
> does not literally change with the phase of the moon.
> 
> Michal

Thanks for reviewing. I removed them in my copy. Would that be something
scripts/checkpatch.pl could warn about?

Regards,

Frank


