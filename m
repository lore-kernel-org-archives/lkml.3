Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3EVVVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:21:10 -0400
Received: from longford.logfs.org ([213.229.74.203]:59230 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3EVVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:21:08 -0400
Date: Wed, 22 May 2013 15:52:47 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] mpt2sas/mpt3sas: prevent double free on error path
Message-ID: <20130522195247.GC7399@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
 <1368132193-25817-3-git-send-email-joern@logfs.org>
 <20130522134817.7870812723bb720633c2b0b2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130522134817.7870812723bb720633c2b0b2@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 13:48:17 -0700, Andrew Morton wrote:
> 
> It's regrettable that this bugfix is joined at the hip with a new
> kernel feature.

Not merged at the hip, I merely ended up reusing an old temp directory
for the new patch series (hips for brains?).  Ignore this patch.

Jörn

--
No art, however minor, demands less than total dedication if you want
to excel in it.
-- Leon Battista Alberti
