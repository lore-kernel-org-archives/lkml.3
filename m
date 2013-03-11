Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3CKWwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:52:12 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47228 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3CKWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:52:11 -0400
Date: Mon, 11 Mar 2013 23:52:05 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Cc: dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch, airlied@linux.ie,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: don't cast kzalloc() return value
Message-ID: <20130311225205.GB3872@bremse>
Mail-Followup-To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>,
	dri-devel@lists.freedesktop.org, airlied@linux.ie,
	linux-kernel@vger.kernel.org
References: <1362918168-20271-1-git-send-email-mihneadb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362918168-20271-1-git-send-email-mihneadb@gmail.com>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 02:22:48PM +0200, Mihnea Dobrescu-Balaur wrote:
> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
