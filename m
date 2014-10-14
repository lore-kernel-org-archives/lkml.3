Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaJNWnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:43:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaJNWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:43:50 -0400
Date: Tue, 14 Oct 2014 15:43:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/1] fallocate: create FAN_MODIFY and IN_MODIFY events
Message-Id: <20141014154349.ca831a4d1e5c1747779552ec@linux-foundation.org>
In-Reply-To: <54342FC2.7030509@gmx.de>
References: <1412287587-5392-1-git-send-email-xypron.glpk@gmx.de>
	<1412324370-959-1-git-send-email-xypron.glpk@gmx.de>
	<20141006141227.GF7526@quack.suse.cz>
	<5432E921.7040306@gmx.de>
	<20141007180559.GC30038@quack.suse.cz>
	<54342FC2.7030509@gmx.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2014 20:24:02 +0200 Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:

> Hello Andrew,
> 
> the patch in
> https://lkml.org/lkml/2014/10/3/56
> and cited below was reviewed by Jan Kara.
> 

Jan wondered why we generate events for FALLOC_FL_KEEP_SIZE, so other
people will wonder the same thing.  We should tell them.  Via code
comments and/or changelogging.

Any question which a reviewer asks should be viewed as a defect in the
patch.  The patch isn't finished until people can read it without
having questions.

