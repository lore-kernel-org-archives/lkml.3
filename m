Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaCNXbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:31:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbaCNXbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:31:21 -0400
Date: Fri, 14 Mar 2014 23:32:14 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: mourn <mourn@2600fr.org>
Cc: Mark Einon <mark@einon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        rebecca@android.com
Subject: Re: [PATCH] staging: android: fix coding style
Message-ID: <20140314233214.GA1124@kroah.com>
References: <1394703895-9588-1-git-send-email-mourn@2600fr.org>
 <20140313135046.GA7083@laugharne.auvation.com>
 <20140313135416.GB7083@laugharne.auvation.com>
 <01095ac2f40e88e8736294e68c2fac05.squirrel@ssl0.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01095ac2f40e88e8736294e68c2fac05.squirrel@ssl0.ovh.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:13:04PM +0100, mourn wrote:
> 
> > The changes look good, however you should be a bit more specific about
> > what the
> > fixes are, and that you used checkpatch.pl to find them (I assume).
> >
> 
> Yes, you are right. I can edit the commit log.
> 
> > Also, Signed-off-by: should state your full name, which I'm also assuming
> > isn't
> > 'mourn'. Please see Documentation/SubmittingPatches.
> >
> 
> I have a bit of a problem here. Some companies forbid their employees to
> openly participate in open source projects. A request to the legal
> department will take around 6 months with no hope of positive result...

Then I can not take your patch, sorry, we can not take anonymous
patches, as the documentation that describes what you mean by adding the
"Signed-off-by:" line to a patch.

good luck with your legal department,

greg k-h
