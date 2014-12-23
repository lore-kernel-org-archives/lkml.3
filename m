Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaLWF6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:58:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaLWF6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:58:23 -0500
Date: Mon, 22 Dec 2014 21:58:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: samuel kihahu <skihahu@gmail.com>
Cc: devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org,
        oleg.drokin@intel.com
Subject: Re: [PATCH] staging: lustre: cleanup align switch and case
Message-ID: <20141223055823.GC824@kroah.com>
References: <1419281337-4076-1-git-send-email-skihahu@gmail.com>
 <20141222211801.GA29847@kroah.com>
 <20141223043804.GA2623@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223043804.GA2623@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 07:38:04AM +0300, samuel kihahu wrote:
> On Mon, Dec 22, 2014 at 01:18:01PM -0800, Greg KH wrote:
> > On Mon, Dec 22, 2014 at 11:48:57PM +0300, samuel kihahu wrote:
> > > From: skihahu <skihahu@gmail.com>
> > > 
> > > Align switch and case to be at the same indent.
> > > 
> > > Signed-off-by: samuel kihahu <skihahu@gmail.com>
> > 
> > The "From:" and "Signed-off-by:" names don't match, which doesn't make
> > much sense, right?  Please fix and resend.
> > 
> 
> I have corrected as requested above.

> >From 766dd7eefe8992b90dc69cca085e6719019aae82 Mon Sep 17 00:00:00 2001
> From: samuel kihahu <skihahu@gmail.com>
> Date: Mon, 22 Dec 2014 18:16:29 +0300
> Subject: [PATCH] staging: lustre: cleanup align switch and case
> 
> Align switch and case to be at the same indent.
> 
> Signed-off-by: samuel kihahu <skihahu@gmail.com>
> ---
>  drivers/staging/lustre/lnet/selftest/module.c | 50 +++++++++++++--------------
>  1 file changed, 25 insertions(+), 25 deletions(-)

But this isn't in a form I can apply, please resend in a format I don't
have to hand-edit the email.

greg k-h
