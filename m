Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3EVV3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:29:05 -0400
Received: from longford.logfs.org ([213.229.74.203]:59239 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3EVV3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:29:03 -0400
Date: Wed, 22 May 2013 16:00:43 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 09/14] bcon: remove version 1.0 support
Message-ID: <20130522200043.GE7399@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
 <1368132193-25817-12-git-send-email-joern@logfs.org>
 <20130522134837.f182d16882468e9e968f2647@linux-foundation.org>
 <20130522195108.GB7399@logfs.org>
 <20130522142532.58540f4917d6f5e89adf671c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130522142532.58540f4917d6f5e89adf671c@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 14:25:32 -0700, Andrew Morton wrote:
> 
> Well I do think a significant amount of change is needed, in particular
> some more use of the /* operator.

Ack.

> Can you set up a new tree for that and for linux-next and leave the
> existing one in place?

Will do.  May take a few days, this is a busy time.

Jörn

--
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
