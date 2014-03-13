Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaCMOEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:04:09 -0400
Received: from einonm.plus.com ([80.229.23.162]:50257 "EHLO mail.einon.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaCMOEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:04:07 -0400
Date: Thu, 13 Mar 2014 13:54:17 +0000
From: Mark Einon <mark@einon.net>
To: mourn@2600fr.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        rebecca@android.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix coding style
Message-ID: <20140313135416.GB7083@laugharne.auvation.com>
References: <1394703895-9588-1-git-send-email-mourn@2600fr.org>
 <20140313135046.GA7083@laugharne.auvation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313135046.GA7083@laugharne.auvation.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try that again...

On Thu, Mar 13, 2014 at 01:50:47PM +0000, Mark Einon wrote:
> On Thu, Mar 13, 2014 at 10:44:55AM +0100, mourn@2600fr.org wrote:
> > From: mourn <mourn@2600fr.org>
> > 
> > Signed-off-by: mourn <mourn@2600fr.org>
> > ---
> >  drivers/staging/android/uapi/ion.h |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 

The changes look good, however you should be a bit more specific about what the
fixes are, and that you used checkpatch.pl to find them (I assume).

Also, Signed-off-by: should state your full name, which I'm also assuming isn't
'mourn'. Please see Documentation/SubmittingPatches.

Cheers,

Mark


