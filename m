Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3KDQUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:20:03 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:34185 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3KDQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:20:00 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ryan Mallon <rmallon@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        utz.bacher@de.ibm.com, mmarek@suse.cz, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <52716E2D.8060708@gmail.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131030173521.GB20147@kroah.com>  <52716E2D.8060708@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:19:51 +0100
Message-ID: <1383581991.15642.7.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-1948-0000-0000-000006C919BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 31.10.2013, 07:38 +1100 schrieb Ryan Mallon:
> On 31/10/13 04:35, Greg KH wrote:
> 
> > On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> >> +if GENWQE
> >> +
> >> +config GENWQE_DEVNAME
> >> +        string "Name for sysfs and device nodes"
> >> +	default "genwqe"
> >> +        help
> >> +          Select alternate name for sysfs and device nodes.
> > 
> > Don't let the user pick this, it's up to the driver to set this once and
> > then live with it.
> > 
> > And, from what I can tell in the driver, this help text is wrong (there
> > are no device nodes with this name in it, right?)
> 
> 
> The indentation is also messed up here. Kconfig should use hard tabs, with
> two additional spaces for the help text. This has mixed tabs and spaces
> between lines.
> 

Ok. Removed it anyways.

> ~Ryan
> 
> 

Regards

Frank


