Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaFXCfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:35:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:55491 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaFXCfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:35:09 -0400
Message-ID: <1403577290.4587.148.camel@pasglop>
Subject: Re: [PATCH 04/24] powerpc: check/return actual error on sysfs
 functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jun 2014 12:34:50 +1000
In-Reply-To: <20140617192334.GA4628@kroah.com>
References: <53A0512D.1090909@oracle.com> <20140617192334.GA4628@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 12:23 -0700, Greg KH wrote:
> On Tue, Jun 17, 2014 at 10:31:09PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > ---
> >  arch/powerpc/platforms/powernv/opal-dump.c | 2 +-
> >  arch/powerpc/platforms/powernv/opal-elog.c | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Ben and Paul, please do not take this patch, it is incorrect.

Thanks, ignored :-)

Cheers,
Ben.


