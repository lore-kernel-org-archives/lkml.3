Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbbA2Jip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:38:45 -0500
Received: from hofr.at ([212.69.189.236]:38413 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbbA2Jil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:38:41 -0500
Date: Thu, 29 Jan 2015 10:38:39 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] hyperv: hyperv_fb.c: match
	wait_for_completion_timeout return type
Message-ID: <20150129093839.GB23666@opentech.at>
References: <1422197222-7967-1-git-send-email-der.herr@hofr.at> <54C62D07.3040603@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C62D07.3040603@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Tomi Valkeinen wrote:

> Hi,
> 
> On 25/01/15 16:47, Nicholas Mc Guire wrote:
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> > ---
> > 
> > v2: fixed subject line
> > 
> > The return type of wait_for_completion_timeout is unsigned long not
> > int. This patch fixes up the declarations only.
> > 
> > Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
> > CONFIG_HYPERV=m, CONFIG_FB_HYPERV=m
> 
> Why didn't you set the text above as the patch description (which is
> empty at the moment)?
> 
basically because the one-line is sufficient to understand the patch
and the rest of the information is not relevant for the git log but only
for the review

if you think it is necessary to understand the patch I'll move it and
resubmit.

thanks for your review !

hofrat
