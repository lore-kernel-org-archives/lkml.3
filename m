Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3KMMgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:36:25 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53268 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3KMMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:36:22 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131112135004.GA31957@amd.pavel.ucw.cz>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <20131112135004.GA31957@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 13 Nov 2013 13:36:13 +0100
Message-ID: <1384346173.15772.9.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111312-4966-0000-0000-0000077DE6D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Am Dienstag, den 12.11.2013, 14:50 +0100 schrieb Pavel Machek:
> Hi!
> 
> > The GenWQE device is a PCIe card used to acclerate different tasks.
> > Since it is configurable, it can be adjusted to different purposes.
> > Our initial task for the card is to do zlib style compression/decompression
> > RFC1950, RFC1951, and RFC1952.
> 
> Is it similar to the Intel's Xeon Phi? They basically many-core have
> computer on PCI card...
> 

No, I think it is not the same. The GenWQE PCIe card is not a
multi-processor card. One cannot run software  on it.

Our GenWQE card can be configured by updating it with different
bitstreams to perform different purposes. The service logic to perform
such updates stays of course the same and the work-queue too. But the
request one can put onto this work-queue can be of different nature.
Currently we can do things like compression, decompression, calculate a
CRC, copy data ...

Regards

Frank


