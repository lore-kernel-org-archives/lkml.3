Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaAMWk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:40:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAMWkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:40:25 -0500
Date: Mon, 13 Jan 2014 14:41:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pol Eyschen <poleyschen@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mark Einon <mark@einon.net>,
        devel@driverdev.osuosl.org, jack@suse.cz, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, ufimtseva@gmail.com
Subject: Re: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
Message-ID: <20140113224101.GA17837@kroah.com>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
 <20140113213552.GA5368@einon.net>
 <20140113214429.GH7444@mwanda>
 <CF9619EF-B1AE-4F7D-B080-E5D4B5625474@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF9619EF-B1AE-4F7D-B080-E5D4B5625474@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:31:29PM +0100, Pol Eyschen wrote:
> 
> On 13.01.2014, at 22:44, Dan Carpenter wrote:
> 
> > On Mon, Jan 13, 2014 at 09:35:53PM +0000, Mark Einon wrote:
> >> On Mon, Jan 13, 2014 at 08:41:40PM +0100, Pol Eyschen wrote:
> >>> From: Pol Eyschen <poleyschen@hotmail.com>
> >>> 
> >>> All comments fixed to match the kernel coding style.
> >>> 
> >>> Signed-off-by: Pol Eyschen <poleyschen@gmail.com>
> >>> ---
> >> 
> >> This patch doesn't apply to my staging-next branch. Are you making your
> >> changes to the staging-next branch of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git?
> >> 
> 
> I cloned
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git and
> made my changes to that branch.

That is Linus's tree, not "linux-next" which we all develop against.

thanks,

greg k-h
