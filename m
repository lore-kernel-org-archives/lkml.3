Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaKZBQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:16:37 -0500
Received: from imap.thunk.org ([74.207.234.97]:51987 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaKZBQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:16:35 -0500
Date: Tue, 25 Nov 2014 20:16:23 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [1/1] fs-ext4: Deletion of an unnecessary check before the
 function call "iput"
Message-ID: <20141126011623.GA20977@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	SF Markus Elfring <elfring@users.sourceforge.net>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, trivial@kernel.org,
	Coccinelle <cocci@systeme.lip6.fr>
References: <54679938.3020106@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54679938.3020106@users.sourceforge.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 07:19:36PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 15 Nov 2014 19:04:06 +0100
> 
> The iput() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks, applied.

						- Ted
