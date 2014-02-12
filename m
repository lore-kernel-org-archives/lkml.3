Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaBLQUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:20:37 -0500
Received: from imap.thunk.org ([74.207.234.97]:57097 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbaBLQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:20:33 -0500
Date: Wed, 12 Feb 2014 11:20:30 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] ext4: Add __init macro to init_inodecache
Message-ID: <20140212162030.GC14520@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
References: <20140201191007.59012c84446860984e6c4a76@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140201191007.59012c84446860984e6c4a76@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 07:10:07PM +0800, Fabian Frederick wrote:
> init_inodecache is only called by __init init_ext4_fs.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.

					- Ted
