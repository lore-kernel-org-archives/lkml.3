Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbaGUTMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:12:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:48218 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419AbaGUTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:12:33 -0400
Date: Mon, 21 Jul 2014 15:11:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Olof Johansson <olof@lixom.net>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
Message-ID: <20140721191148.GB24960@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Olof Johansson <olof@lixom.net>,
	Chen Gang <gang.chen.5i5j@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <53C47E59.8030502@gmail.com>
 <20140715093154.GB1451@thunk.org>
 <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:40:02AM -0700, Olof Johansson wrote:
> > I'll respin the "ext4: rearrange initialization to fix EXT4FS_DEBUG"
> > commit to include this fix and give you credit in the commit logs for
> > pointing out this issue.
> 
> Friendly ping, since all !SMP builds in -next seem to be broken by this still.

Right, sorry, I'm currently in vacation in Rome, and the network
connection was really lousy here now that I'm no longer at the ACACES
summer school in Fiuggi.  (Also, now that I'm no longer actually
teaching, I've beeen trying to actually do the disconnecting and
sightseeing thing.  :-)

Pushed now.

						- Ted
