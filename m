Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3I2Xw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab3I2Xwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:52:55 -0400
Date: Sun, 29 Sep 2013 19:52:33 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Liu <gnehzuil.liu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 062/117] ext4: fix ext4_writepages() in presence of truncate
Message-ID: <20130929235233.GA26301@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
 <20130925001747.625543023@linuxfoundation.org>
 <1380496031.14493.3.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380496031.14493.3.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 12:07:11AM +0100, Ben Hutchings wrote:
 > On Tue, 2013-09-24 at 17:18 -0700, Greg Kroah-Hartman wrote:
 > > 3.11-stable review patch.  If anyone has any objections, please let me know.
 > > 
 > > ------------------
 > > 
 > > From: Jan Kara <jack@suse.cz>
 > > 
 > > commit 5f1132b2ba8c873f25982cf45917e8455fb6c962 upstream.
 > [...]
 > 
 > Is this needed for any older kernel versions?

I can't speak authoriatively, but I only started triggering it with 3.11-rc.

	Dave
 
