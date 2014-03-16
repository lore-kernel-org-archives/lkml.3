Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaCPDRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 23:17:55 -0400
Received: from imap.thunk.org ([74.207.234.97]:42036 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaCPDRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 23:17:53 -0400
Date: Sat, 15 Mar 2014 23:17:45 -0400
From: tytso@mit.edu
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [v7] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Message-ID: <20140316031745.GA9916@thunk.org>
Mail-Followup-To: tytso@mit.edu, NamJae Jeon <linkinjeon@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
References: <1393769538-3784-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393769538-3784-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed I had the v6 version of your patch in my tree.  I've
updated it to be the v7 version, thanks.

	      	     		 - Ted
