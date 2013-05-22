Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3EVVZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:25:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3EVVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:25:33 -0400
Date: Wed, 22 May 2013 14:25:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 09/14] bcon: remove version 1.0 support
Message-Id: <20130522142532.58540f4917d6f5e89adf671c@linux-foundation.org>
In-Reply-To: <20130522195108.GB7399@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-12-git-send-email-joern@logfs.org>
	<20130522134837.f182d16882468e9e968f2647@linux-foundation.org>
	<20130522195108.GB7399@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 15:51:09 -0400 J__rn Engel <joern@logfs.org> wrote:

> On Wed, 22 May 2013 13:48:37 -0700, Andrew Morton wrote:
> > On Thu,  9 May 2013 16:43:07 -0400 Joern Engel <joern@logfs.org> wrote:
> > 
> > > Very few machines ever ran with 1.0 format and by now I doubt whether a
> > > single one still does.  No need to carry that code along.
> > 
> > aw geeze.  Can we please clean up the patch series?
> 
> People started using my git tree, so I decided to keep it stable and
> not fold fixes into the main patch.  That admittedly sucks for review.
> 
> Would you like me to create a single patch for review?  And after
> that, do you want to carry a single patch in your series or should I
> keep my tree and try to get that merged?  Either way works for me.
> 

Well I do think a significant amount of change is needed, in particular
some more use of the /* operator.

Can you set up a new tree for that and for linux-next and leave the
existing one in place?
