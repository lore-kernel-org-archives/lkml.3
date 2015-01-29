Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbbA2Jr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:47:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50280 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbbA2JrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:47:23 -0500
Date: Thu, 29 Jan 2015 12:47:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] hyperv: hyperv_fb.c: match
 wait_for_completion_timeout return type
Message-ID: <20150129094704.GT6456@mwanda>
References: <1422197222-7967-1-git-send-email-der.herr@hofr.at>
 <54C62D07.3040603@ti.com>
 <20150129093839.GB23666@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129093839.GB23666@opentech.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 10:38:39AM +0100, Nicholas Mc Guire wrote:
> On Mon, 26 Jan 2015, Tomi Valkeinen wrote:
> 
> > Hi,
> > 
> > On 25/01/15 16:47, Nicholas Mc Guire wrote:
> > > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> > > ---
> > > 
> > > v2: fixed subject line
> > > 
> > > The return type of wait_for_completion_timeout is unsigned long not
> > > int. This patch fixes up the declarations only.
> > >

This line is relevant for the patch description.
 
> > > Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
> > > CONFIG_HYPERV=m, CONFIG_FB_HYPERV=m

This line is not relevant.

regards,
dan carpenter


