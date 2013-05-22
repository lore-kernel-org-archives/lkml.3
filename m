Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3EVVTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:19:31 -0400
Received: from longford.logfs.org ([213.229.74.203]:59225 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3EVVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:19:30 -0400
Date: Wed, 22 May 2013 15:51:09 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 09/14] bcon: remove version 1.0 support
Message-ID: <20130522195108.GB7399@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
 <1368132193-25817-12-git-send-email-joern@logfs.org>
 <20130522134837.f182d16882468e9e968f2647@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130522134837.f182d16882468e9e968f2647@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 13:48:37 -0700, Andrew Morton wrote:
> On Thu,  9 May 2013 16:43:07 -0400 Joern Engel <joern@logfs.org> wrote:
> 
> > Very few machines ever ran with 1.0 format and by now I doubt whether a
> > single one still does.  No need to carry that code along.
> 
> aw geeze.  Can we please clean up the patch series?

People started using my git tree, so I decided to keep it stable and
not fold fixes into the main patch.  That admittedly sucks for review.

Would you like me to create a single patch for review?  And after
that, do you want to carry a single patch in your series or should I
keep my tree and try to get that merged?  Either way works for me.

Jörn

--
Ninety percent of everything is crap.
-- Sturgeon's Law
