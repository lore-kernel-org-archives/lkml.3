Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaIBCQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 22:16:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:60000 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaIBCQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 22:16:11 -0400
Date: Mon, 1 Sep 2014 22:16:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Seunghun Lee <waydi1@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix comments about get_blocks
Message-ID: <20140902021609.GQ8974@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Seunghun Lee <waydi1@gmail.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1409577362-4045-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409577362-4045-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 10:16:02PM +0900, Seunghun Lee wrote:
> get_blocks is renamed to get_block.
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

Applied, thanks.

					- Ted
