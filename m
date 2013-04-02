Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761821Ab3DBQf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:35:56 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58457 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab3DBQfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:35:55 -0400
Date: Tue, 2 Apr 2013 12:35:44 -0400
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
Subject: Re: [PATCH 26/33] aio: don't include aio.h in sched.h
Message-ID: <20130402163543.GJ31577@thunk.org>
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
 <1363883754-27966-27-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-27-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:47AM -0700, Kent Overstreet wrote:
> Faster kernel compiles by way of fewer unnecessary includes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
