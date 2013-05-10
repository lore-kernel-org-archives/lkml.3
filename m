Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3EJT1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:27:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab3EJT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:27:53 -0400
Date: Fri, 10 May 2013 15:27:47 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: EUNBONG SONG <eunb.song@samsung.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Message-ID: <20130510192747.GA11707@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6719519.5821368147110937.JavaMail.weblogic@epml17>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, since you seem to be able to reproduce the problem reliably, any
chance you can try bisecting the problem?  I've looked at the commits
that touch fs/jbd2 and nothing is jumping out at me.

Also, how many CPU's do you have your system, and what kind of storage
device were you using when you were running iozone (5400rpm HDD,
7200RPM HDD, RAID array, SSD, etc.)?

Thanks,

						- Ted
