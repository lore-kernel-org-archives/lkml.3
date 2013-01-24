Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945953Ab3AXV2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:28:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3AXV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:28:00 -0500
Date: Thu, 24 Jan 2013 13:27:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Valdis.Kletnieks@vt.edu, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, zab@zabbo.net, linux-fsdevel@vger.kernel.org
Subject: Re: next-20130117 - kernel BUG with aio
Message-Id: <20130124132759.c892fb4c.akpm@linux-foundation.org>
In-Reply-To: <20130124211850.GH26407@google.com>
References: <3544.1358774694@turing-police.cc.vt.edu>
	<CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
	<2553.1358890098@turing-police.cc.vt.edu>
	<CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
	<13450.1359048141@turing-police.cc.vt.edu>
	<20130124211850.GH26407@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013 13:18:50 -0800
Kent Overstreet <koverstreet@google.com> wrote:

> So, Andrew - that "smoosh struct kiocb" patch should just be dropped,
> even if I fixed that issue clearly the idea is a lot less safe than I
> thought. I've got patches for the other stuff I'm going to mail out
> momentarily.

Dropped.  Do you expect that this will fix everything?

Please cc linux-fsdevel on the aio stuff - I'm seeing some AIO things
over there which aren't cc'ed to lkml or linux-aio.

Please also take a look at Jan's recent
http://www.spinics.net/lists/linux-fsdevel/msg61738.html and have a
think about how this plays with your patchset.

