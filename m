Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3H1SVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:21:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:50747 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab3H1SVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:21:01 -0400
Date: Wed, 28 Aug 2013 14:20:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andi Shyti <andi@etezian.org>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: extents: len and lblock may be used uninitialized
Message-ID: <20130828182056.GB27079@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andi Shyti <andi@etezian.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1374712385-6691-1-git-send-email-andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374712385-6691-1-git-send-email-andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 02:33:05AM +0200, Andi Shyti wrote:
> if ext_debugging is enabled and path[depth].p_ext is NULL, len
> and lblock are printed non initialized
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>

Thanks, applied.

						- Ted
