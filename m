Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaLVDz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:55:57 -0500
Received: from ozlabs.org ([103.22.144.67]:59313 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaLVDz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:55:56 -0500
Message-ID: <1419220554.20221.4.camel@ellerman.id.au>
Subject: Re: [PATCH] misc: cxl: sysfs.c: Remove unused function
From: Michael Ellerman <mpe@ellerman.id.au>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        Ian Munsie <imunsie@au1.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Dec 2014 14:55:54 +1100
In-Reply-To: <CAFo99ga9TYf5hnwOcoRPKsTHhhknoz6_axzP7spe0mvd=YPMLw@mail.gmail.com>
References: <1419092024-6701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1419134735.27324.41.camel@neuling.org>
	 <CAFo99ga9TYf5hnwOcoRPKsTHhhknoz6_axzP7spe0mvd=YPMLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-21 at 13:46 +0100, Rickard Strandqvist wrote:
> 2014-12-21 5:05 GMT+01:00 Michael Neuling <mikey@neuling.org>:
> >> Remove the function mmio_size_show() that is not used anywhere.
> >
> > Did you compile check this patch?
> >
> >   drivers/misc/cxl/sysfs.c:291:74: error: ‘mmio_size_show’ undeclared here (not in a function)
> >
> > It's used here:
> >         static struct device_attribute afu_attrs[] = {
> >                 __ATTR_RO(mmio_size),
> 
> Hi
> 
> Sorry about that.
> 
> Strange because I compile everything as allyesconfig, allmodconfig and
> allnoconfig.

The allyes should have picked it up, so you must have done something wrong.

Please be more careful with these attribute routines, they are not visible with
grep.

cheers


