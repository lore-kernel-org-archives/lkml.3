Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbbA2KZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:25:28 -0500
Received: from hofr.at ([212.69.189.236]:38943 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbbA2KZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:25:25 -0500
Date: Thu, 29 Jan 2015 11:25:23 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] hyperv: hyperv_fb.c: match
	wait_for_completion_timeout return type
Message-ID: <20150129102523.GA22340@opentech.at>
References: <1422197222-7967-1-git-send-email-der.herr@hofr.at> <54C62D07.3040603@ti.com> <20150129093839.GB23666@opentech.at> <20150129094704.GT6456@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129094704.GT6456@mwanda>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2015, Dan Carpenter wrote:

> On Thu, Jan 29, 2015 at 10:38:39AM +0100, Nicholas Mc Guire wrote:
> > On Mon, 26 Jan 2015, Tomi Valkeinen wrote:
> > 
> > > Hi,
> > > 
> > > On 25/01/15 16:47, Nicholas Mc Guire wrote:
> > > > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> > > > ---
> > > > 
> > > > v2: fixed subject line
> > > > 
> > > > The return type of wait_for_completion_timeout is unsigned long not
> > > > int. This patch fixes up the declarations only.
> > > >
> 
> This line is relevant for the patch description.
>  
> > > > Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
> > > > CONFIG_HYPERV=m, CONFIG_FB_HYPERV=m
> 
> This line is not relevant.
>
thanks - will resend it then - assumed that the one-line would do for this
patch.

thx!
hofrat 
