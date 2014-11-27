Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaK0Pib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:38:31 -0500
Received: from imap.thunk.org ([74.207.234.97]:55357 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaK0Pi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:38:29 -0500
Date: Thu, 27 Nov 2014 10:38:24 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ext4: possible unsafe locking scenario
Message-ID: <20141127153824.GD14091@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20141126145951.GA2750@swordfish>
 <20141126152821.GA4004@thunk.org>
 <20141127123211.GA1001@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127123211.GA1001@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, OK, I know what's going in; this should be fixed soon.  Thanks for
reporting it, and my apologies for the inconvenience.

    	       	      	    	     	    - Ted
