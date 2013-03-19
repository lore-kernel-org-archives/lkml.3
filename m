Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab3CSSGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:06:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60505 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab3CSSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:06:08 -0400
Date: Tue, 19 Mar 2013 19:05:56 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: drm/i915: new warning (regression) in 3.7.10 and 3.8.3
Message-ID: <20130319180556.GA2439@netboy.at.omicron.at>
References: <20130316122849.GA3753@netboy.at.omicron.at>
 <20130318083251.GQ9021@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318083251.GQ9021@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:32:51AM +0100, Daniel Vetter wrote:
> 
> Another pesky BIOS which changes the display state behind our back on lid
> closing! Should be duct-tapped over with
> 
> commit 45e2b5f640b3766da3eda48f6c35f088155c06f3
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Fri Nov 23 18:16:34 2012 +0100
> 
>     drm/i915: force restore on lid open
> 
> which is in 3.8.

But that warning was from a 3.8.3 kernel. Any other ideas?

Thanks,
Richard

