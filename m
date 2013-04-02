Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab3DBPr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:47:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58338 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348Ab3DBPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:47:25 -0400
Date: Tue, 2 Apr 2013 11:47:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/33] aio: change reqs_active to include unreaped
 completions
Message-ID: <20130402154701.GD31577@thunk.org>
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
 <1363883754-27966-18-git-send-email-koverstreet@google.com>
 <20130402025350.GF30122@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402025350.GF30122@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:53:50PM -0400, Theodore Ts'o wrote:
> Could you please add a quick comment documenting the reqs_active field
> in the struct kioctx definition here?  For future code
> maintainability, it should be documented in fs/aio.c, not just in a
> commit description.

I see this field gets changed yet again in "aio: reqs_active ->
reqs_available" and it's documented appropritaely after that commit....

		    	 	    		  - Ted
