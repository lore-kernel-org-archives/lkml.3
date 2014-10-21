Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaJUI4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:56:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35592 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaJUI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:56:12 -0400
Date: Tue, 21 Oct 2014 10:56:19 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Masanari Iida <standby24x7@gmail.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, trivial@kernel.org
Subject: Re: [PATCH] gpu:drm: Fix typo in Documentation/DocBook/drm.xml
Message-ID: <20141021085619.GY26941@phenom.ffwll.local>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	corbet@lwn.net, trivial@kernel.org
References: <1413816793-14690-1-git-send-email-standby24x7@gmail.com>
 <54453FA4.3090009@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54453FA4.3090009@infradead.org>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:00:20AM -0700, Randy Dunlap wrote:
> On 10/20/14 07:53, Masanari Iida wrote:
> > This patch fix spelling typos found in drm.xml.
> > It is because the file is generated from comments in
> > source codes, I have to fix the typos within source files.
> > 
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied to my drm trivial patch queue to make sure it won't get lost.
Should show up in linux-next soonish.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
