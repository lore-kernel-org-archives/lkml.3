Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaLFWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:16:28 -0500
Received: from imap.thunk.org ([74.207.234.97]:43558 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaLFWQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:16:27 -0500
Date: Sat, 6 Dec 2014 17:16:21 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: next-20141204 crashing on ext4_fill_super()
Message-ID: <20141206221621.GB27484@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Murilo Opsfelder Araujo <mopsfelder@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
References: <2144577.XOl86X9GoH@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2144577.XOl86X9GoH@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please revert fdfe07398761 and that should the crashes; this will be
fixed in the next linux-next release.  My apologies for the inconvenience.

      	     	  	     	       	  	    - Ted
