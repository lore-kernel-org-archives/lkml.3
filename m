Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbaGRLvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:51:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:43074 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761417AbaGRLvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:51:39 -0400
Date: Fri, 18 Jul 2014 07:51:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org,
        deraadt@cvs.openbsd.org
Subject: Re: [PATCH, RFC -v3] random: introduce getrandom(2) system call
Message-ID: <20140718115122.GG1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Richard Weinberger <richard.weinberger@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org,
	deraadt@cvs.openbsd.org
References: <1405677564-16802-1-git-send-email-tytso@mit.edu>
 <CAFLxGvy7CwWiagxMHixHnuUwvimBOOJyJqs4g2Rq8hzoUA60mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvy7CwWiagxMHixHnuUwvimBOOJyJqs4g2Rq8hzoUA60mw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:25:17PM +0200, Richard Weinberger wrote:
> >                     if (ret != buflen)
> 
> A small nit-pick, missing "{".

Thanks, good catch.   Fixed.

						- Ted
