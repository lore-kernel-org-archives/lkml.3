Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946869Ab3BHRuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:50:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946582Ab3BHRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:50:43 -0500
Date: Fri, 8 Feb 2013 09:50:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-Id: <20130208095041.5ad9669e.akpm@linux-foundation.org>
In-Reply-To: <20130208144902.GQ15092@kernel.dk>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-26-git-send-email-koverstreet@google.com>
	<20130208144408.GY2875@htj.dyndns.org>
	<20130208144902.GQ15092@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 15:49:02 +0100 Jens Axboe <axboe@kernel.dk> wrote:

> > > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > 
> > What's the status of this series?  The percpu-refcnt part is still
> > going through review and the merge window is opening up pretty soon.
> > Kent, Andrew?
> 
> I'd feel a lot better deferring the whole aio/dio performance series for
> one merge window. There's very little point in rushing it, and I don't
> think it's been reviewed/tested enough yet.

OK by me.
