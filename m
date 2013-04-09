Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936545Ab3DIVID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:08:03 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57192 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936415Ab3DIVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:07:59 -0400
Date: Tue, 9 Apr 2013 14:07:56 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/33] aio: use flush_dcache_page()
Message-ID: <20130409210756.GK15749@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-16-git-send-email-koverstreet@google.com>
 <20130402021229.GD30122@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402021229.GD30122@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:12:29PM -0400, Theodore Ts'o wrote:
> The commit description needs to explain why flush_dcache_page() is
> needed now, but wasn't needed before.

It wasn't causing problems before because it's not needed on x86, but it
is needed on other architectures. Added that to the commit description.
