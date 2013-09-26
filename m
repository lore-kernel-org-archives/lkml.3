Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3IZBK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:10:59 -0400
Received: from imap.thunk.org ([74.207.234.97]:38112 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3IZBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:10:58 -0400
Date: Wed, 25 Sep 2013 21:10:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Holler <holler@ahsoftware.de>, Joe Perches <joe@perches.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-ID: <20130926011049.GA22026@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Holler <holler@ahsoftware.de>,
	Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1380047934.3575.100.camel@joe-AO722>
 <20130925152432.GY13318@ZenIV.linux.org.uk>
 <1380123344.17366.5.camel@joe-AO722>
 <20130925161949.GZ13318@ZenIV.linux.org.uk>
 <1380136920.17366.15.camel@joe-AO722>
 <20130925193035.GA11905@thunk.org>
 <1380138515.17366.22.camel@joe-AO722>
 <52433F89.5050104@ahsoftware.de>
 <20130925130352.0e89fd9439eff93c69cdcc32@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925130352.0e89fd9439eff93c69cdcc32@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 01:03:52PM -0700, Andrew Morton wrote:
> 
> Nobody uses --strict.  Discussion is silly.

If "nobody" uses it, why is it there?

   	    	     	    - Ted
