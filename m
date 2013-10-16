Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3JPDhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 23:37:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:46670 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3JPDhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 23:37:03 -0400
Date: Tue, 15 Oct 2013 23:36:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stefan Beller <stefanbeller@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random.c: fix a typo in comments
Message-ID: <20131016033659.GE28823@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stefan Beller <stefanbeller@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <1381156729-1814-1-git-send-email-stefanbeller@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381156729-1814-1-git-send-email-stefanbeller@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 04:38:49PM +0200, Stefan Beller wrote:
> Also removes (trailing) tabs from an empty line.
> 
> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>

Thanks for sending the patch, but the comments in this section have
since been reworded in random.git, so this patch is no longer
applicable to the random.git tree which will be pushed upstream at the
next merge window.

Cheers,

						- Ted
