Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaA0PaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:30:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49483 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753483AbaA0PaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:30:13 -0500
Date: Mon, 27 Jan 2014 10:30:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
In-Reply-To: <CAKMK7uHFmYfjdmUrW34qzp1+q99jzvzYe47E-ZCtAT88eSSavQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1401271024570.1207-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Daniel Vetter wrote:

> On Tue, Jan 14, 2014 at 3:43 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Don't bother.  I'll redo it using the drm-intel-nightly branch, but I
> > won't have time for a few days.
> 
> My apologies for the delay in getting around to this. Can you please
> test the patch i've just posted?
> 
> http://patchwork.freedesktop.org/patch/18810/

I will.

By the way, I tried getting an up-to-date version of your 
drm-intel-nightly branch, and ended up with the following:

$ git clone --depth 1 -b drm-intel-nightly http://cgit.freedesktop.org/~danvet/drm-intel/
Cloning into 'drm-intel'...
fatal: dumb http transport does not support --depth

(I can't remember what happened the first time I tried to clone your 
repository).  So I will try running with this patch on top of 3.13.

Alan Stern

