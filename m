Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaH0LEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:04:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44437 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbaH0LET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:04:19 -0400
Date: Wed, 27 Aug 2014 14:04:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Remove various orphaned header files
Message-ID: <20140827110407.GJ5046@mwanda>
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
 <1403631263.29061.17.camel@joe-AO725>
 <8761hksfnf.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761hksfnf.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 05:33:24PM +0200, Rasmus Villemoes wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Tue, 2014-06-24 at 19:27 +0200, Rasmus Villemoes wrote:
> >> AFAICT, these headers are not used anywhere, and are just accidental
> >> leftovers from past cleanups.
> >
> > Thanks.
> 
> Did anyone pick these [1] up? All six files still seem to be present.

Greg is not the right maintainer for most of these.  Resend them to the
correct people.

patch 1 I never received it
patch 2 netdev and Dave M.
patch 3 Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
patch 4 Greg or Dave M, netdev
patch 5 <linux-tegra@vger.kernel.org>
patch 6 netdev and Dave M.

regards,
dan carpenter

