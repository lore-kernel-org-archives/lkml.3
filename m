Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbAVHxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:53:41 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52807 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbAVHxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:53:33 -0500
Date: Thu, 22 Jan 2015 07:53:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com
Subject: Re: linux-next: strange commit in the mfd tree
Message-ID: <20150122075328.GN22024@x1>
References: <20150122095638.46a0b503@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150122095638.46a0b503@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Stephen Rothwell wrote:

> Hi Lee,
> 
> I noticed this commit in the mfd tree:
> 
> f11b9265e6ca "[FIX/HACK] Disable DRM"
> 
> Is that really appropriate here?  Especially given it has no explanation.
> 
> I guess it will make my builds slightly faster :-)

You're right, this is an escapee.  It should have been removed
post-testing.  I have asked Rob Clark to take a look at the issue it
'solves'. FYI, arm,multi_v7 fails to build with raised warning levels
>=1.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
