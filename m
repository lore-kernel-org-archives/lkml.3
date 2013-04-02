Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3DBDDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:03:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58075 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab3DBDDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:03:24 -0400
Date: Mon, 1 Apr 2013 23:03:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 18/33] aio: kill batch allocation
Message-ID: <20130402030313.GG30122@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
	Asai Thambi S P <asamymuthupa@micron.com>,
	Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
	Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-19-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-19-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:39AM -0700, Kent Overstreet wrote:
> Previously, allocating a kiocb required touching quite a few global (well,
> per kioctx) cachelines...  so batching up allocation to amortize those was
> worthwhile.  But we've gotten rid of some of those, and in another couple
> of patches kiocb allocation won't require writing to any shared
> cachelines, so that means we can just rip this code out.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

