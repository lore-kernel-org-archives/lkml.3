Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3CRIaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:30:09 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43520 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3CRIaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:30:06 -0400
Date: Mon, 18 Mar 2013 09:32:51 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: drm/i915: new warning (regression) in 3.7.10 and 3.8.3
Message-ID: <20130318083251.GQ9021@phenom.ffwll.local>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	David Airlie <airlied@linux.ie>
References: <20130316122849.GA3753@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316122849.GA3753@netboy.at.omicron.at>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 01:28:50PM +0100, Richard Cochran wrote:
> 
> I have an Acer Aspire One netbook, and on it I get the following
> warning when closing and opening the lid. I think this warning first
> appeared in 3.7.
> 
> Does this need fixing? If so, who can do it?

Another pesky BIOS which changes the display state behind our back on lid
closing! Should be duct-tapped over with

commit 45e2b5f640b3766da3eda48f6c35f088155c06f3
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Nov 23 18:16:34 2012 +0100

    drm/i915: force restore on lid open

which is in 3.8.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
