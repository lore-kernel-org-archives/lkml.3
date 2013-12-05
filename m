Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3LEMpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:45:49 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:38715 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3LEMpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:45:47 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <201312050327.26152.arnd@arndb.de>
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1386080903-27160-2-git-send-email-haver@linux.vnet.ibm.com>
	 <1386151347.7883.15.camel@oc7383187364.ibm.com>
	 <201312050327.26152.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 05 Dec 2013 13:44:25 +0100
Message-ID: <1386247465.11866.0.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120512-4966-0000-0000-000007B9C8AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Am Donnerstag, den 05.12.2013, 03:27 +0100 schrieb Arnd Bergmann:
> On Wednesday 04 December 2013, Frank Haverkamp wrote:
> > Am Dienstag, den 03.12.2013, 15:28 +0100 schrieb Frank Haverkamp:
> > > + */
> > > +struct genwqe_mem {
> > > +       unsigned long addr;
> > > +       unsigned long size;
> > > +       int direction;
> > > +};
> > > +
> > > +#define GENWQE_PIN_MEM       _IOWR(GENWQE_IOC_CODE, 40, struct
> > > genwqe_mem *)
> > > +#define GENWQE_UNPIN_MEM      _IOWR(GENWQE_IOC_CODE, 41, struct
> > > genwqe_mem *)
> > > + 
> > 
> > Before someone comments on the unsigned long and the 32/64 bit issues
> > with it. I need to fix that.
> 
> Also the extraneous '*' in the definitions.

Ok, I will remove the '*' and just put the structs there.

> 
> 	Arnd
> 
Regards

Frank


