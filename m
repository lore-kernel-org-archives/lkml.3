Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858Ab3DFMlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 08:41:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59783 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422837Ab3DFMlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 08:41:05 -0400
Date: Sat, 6 Apr 2013 08:41:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Michael D. Setzer II" <msetzerii@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Error in linux-3.0.72 build.
Message-ID: <20130406124101.GA7816@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Michael D. Setzer II" <msetzerii@gmail.com>,
	linux-kernel@vger.kernel.org
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515FF835.28644.1FF1E@msetzerii.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> Just downloaded new kernels, and find this error in build.

Patch is here: 

http://www.spinics.net/lists/linux-ext4/msg37598.html

Explanation of why it's needed is here:

http://www.spinics.net/lists/linux-ext4/msg37600.html

Greg has queued it for the next stable release.

Cheers,

						- Ted
