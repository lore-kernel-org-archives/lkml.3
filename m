Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3BBDfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 22:35:03 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:46589 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab3BBDfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 22:35:01 -0500
Date: Fri, 1 Feb 2013 22:34:56 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Cong Ding <dinggnu@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs:ext4:hash.c: reduce one "if" comparison
Message-ID: <20130202033456.GB16364@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Cong Ding <dinggnu@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1354404821-6781-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354404821-6781-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 11:33:41PM +0000, Cong Ding wrote:
> it is unnecessary to check i<4 after the loop. just do it before the break.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Thanks, applied.

					- Ted
