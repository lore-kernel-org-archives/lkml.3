Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaJOTx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:53:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51076 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaJOTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:53:56 -0400
Date: Wed, 15 Oct 2014 22:53:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141015195345.GQ26918@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015123431.GA23154@mwanda>
 <20141015125934.GB23154@mwanda>
 <1413378213.2412.13.camel@jtkirshe-mobl>
 <1413389496.7484.3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413389496.7484.3.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:11:36AM -0700, Joe Perches wrote:
> On Wed, 2014-10-15 at 06:03 -0700, Jeff Kirsher wrote:
> []
> > I thought I remember Greg saying something about getting rid of this
> > driver anyway, but I could be wrong.  If Greg decides to keep this
> > driver around, then I think we should something like your suggestion
> > above.
> 
> Or maybe just make the Kconfig depend on X86_32

What I like about your patches is that they are pure theoretical work
and I don't have to think about them like regular proper patches with a
signed off by etc.  All the fun, none of the responsibility.

>  config BCM_WIMAX
>         tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
> -       depends on USB && NET
> +       depends on USB && NET && X86_32

And also COMPILE_TEST.

regards,
dan carpenter

