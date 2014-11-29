Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaK2Rib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:38:31 -0500
Received: from imap.thunk.org ([74.207.234.97]:58041 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaK2Ri3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:38:29 -0500
Date: Sat, 29 Nov 2014 12:38:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jeremiah Mahler <jmmahler@gmail.com>
Subject: Re: linux-next: manual merge of the block tree with the ext4 tree
Message-ID: <20141129173818.GB4362@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Jeremiah Mahler <jmmahler@gmail.com>
References: <20141127145347.0083c0bc@canb.auug.org.au>
 <20141129100833.GA31892@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141129100833.GA31892@kria>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note the relevant changes from the ext4 tree were dropped from the
dev branch, so this shouldn't be an issue moving forward.

    	       	    	      	    	  - Ted

