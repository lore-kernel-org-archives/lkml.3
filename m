Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbaFSWnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:43:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaFSWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:43:16 -0400
Date: Thu, 19 Jun 2014 15:47:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: devel@driverdev.osuosl.org, waydi1@gmail.com, yangds.fnst@cn.fujitsu.com,
        serban.constantinescu@arm.com, linux-kernel@vger.kernel.org,
        arve@android.com, john.stultz@linaro.org, prtvar.b@gmail.com
Subject: Re: [PATCH] staging: android: binder: Fix 10 overlong lines
Message-ID: <20140619224716.GA8223@kroah.com>
References: <1401578993-24829-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401578993-24829-1-git-send-email-danieru.dressler@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 05:29:53PM -0600, Daniel Dressler wrote:
> This patch was made following Greg Kroah-Hartman's
> newbie guide. It is not intended to make any
> logical alterations to codeflow. Of note to reviews
> this patch switch's a call to kzalloc to kcalloc on
> line 2837
> 
> Neil Brown gave good advice on how to align
> the over-long function calls. He suggested
> using a single tab to indent the arguments.
> Like thus:
> var = function(
> 	arg1, arg2, arg3, arg4);
> 
> I intended to use the style he suggested but
> noticed much of the existing code instead
> aligns the overflow with the first argument
> and tries to give all arguments equal space.
> Like thus:
> var = function(arg1, arg2
> 	       arg3, arg4);
> 
> This second method uses spaces to align the
> arguments.
> 
> Taking a survey of the first 800 lines the
> following lines used each method:
> 
> Method #1: 666, 527, 572
> Method #2: 475, 495, 520, 545, 554, 582, 630,
>            677, 788
> 
> Thus to maintain consistancy this patch uses
> method #1. If method #1 is not acceptable
> please do not hesitate to say so.
> 
> Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
> ---
>  drivers/staging/android/binder.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)

This patch doesn't apply properly to my staging-next branch of the
staging.git tree :(

