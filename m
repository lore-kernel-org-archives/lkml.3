Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3IEQBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:01:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3IEQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:01:18 -0400
Date: Thu, 5 Sep 2013 09:01:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Avi <avi.kp.137@gmail.com>
Cc: klmckinney1@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: drivers/staging/bcm/InterfaceMisc.c-checkpatch
 cleanup-(foo*)->(foo *)
Message-ID: <20130905160117.GA1582@kroah.com>
References: <20130905155154.GA7535@avi-VPCCW15FG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905155154.GA7535@avi-VPCCW15FG>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:21:54PM +0530, Avi wrote:

> >From 91e1d42ce8b52cc28689ea4e56c71b790217cf91 Mon Sep 17 00:00:00 2001
> From: AVI <avi@avi-VPCCW15FG.(none)>

Why have you attached your patch?  And this "From:" line is obviously
wrong :(

> Date: Thu, 5 Sep 2013 21:03:45 +0530
> Subject: [PATCH] drivers/staging/bcm/InterfaceMisc.c:107: ERROR: "(foo*)"
>  should be "(foo *)" 
> Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>

You need to put some type of description in the changelog section.

And a new line before the signed-off-by: line.

Can you just use git send-email to send the patch, and not attach it, so
that I don't have to hand-edit the patch in order to apply it properly?

thanks,

greg k-h
