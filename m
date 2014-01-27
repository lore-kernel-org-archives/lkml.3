Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaA0JDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:03:01 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60906 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0JC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:02:59 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <Pine.LNX.4.44L0.1401140942520.1310-100000@iolanthe.rowland.org>
References: <20140114090519.GP4770@phenom.ffwll.local>
	<Pine.LNX.4.44L0.1401140942520.1310-100000@iolanthe.rowland.org>
Date: Mon, 27 Jan 2014 10:02:58 +0100
X-Google-Sender-Auth: IRTSqdQUcmgAUizqVj4CPFLJZVY
Message-ID: <CAKMK7uHFmYfjdmUrW34qzp1+q99jzvzYe47E-ZCtAT88eSSavQ@mail.gmail.com>
Subject: Re: Excessive WARN()s in Intel 915 driver
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 3:43 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Don't bother.  I'll redo it using the drm-intel-nightly branch, but I
> won't have time for a few days.

My apologies for the delay in getting around to this. Can you please
test the patch i've just posted?

http://patchwork.freedesktop.org/patch/18810/

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
