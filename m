Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbaLLEKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:10:34 -0500
Received: from imap.thunk.org ([74.207.234.97]:52256 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639AbaLLEKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:10:33 -0500
Date: Thu, 11 Dec 2014 23:10:27 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Huang Ying <ying.huang@intel.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [ext4] fdfe0739876: Failed to mount
Message-ID: <20141212041027.GD10189@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Huang Ying <ying.huang@intel.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
References: <1418353365.5745.95.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418353365.5745.95.camel@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:02:45AM +0800, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> After the commit, the file system failed to mount as in stderr file attached.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> commit fdfe073987619ec375da8d8a2701ab271d1b1339 ("ext4: fix potential use after free during resize")

This was dropped from the ext4 dev branch a few days ago....

     	 	      	       	   	    - Ted
