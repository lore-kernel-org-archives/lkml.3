Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3EROKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:10:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:49479 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3EROKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:10:04 -0400
Date: Sat, 18 May 2013 10:09:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: dirk.brandewie@gmail.com
Cc: linux-pm@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] cpufreq/intel_pstate: Add additional supported CPU ID
Message-ID: <20130518140958.GA17314@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, dirk.brandewie@gmail.com,
	linux-pm@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org,
	Dirk Brandewie <dirk.j.brandewie@intel.com>,
	torvalds@linux-foundation.org
References: <1368801497-13072-1-git-send-email-dirk.j.brandewie@gmail.com>
 <1368807024-15251-1-git-send-email-dirk.j.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368807024-15251-1-git-send-email-dirk.j.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 09:10:24AM -0700, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Add CPU ID for Ivybrigde processor.
> 
> Cc: torvalds@linux-foundation.org
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

BTW, there are some good comments about this by Arjan in this G+ post

https://plus.google.com/117091380454742934025/posts/2vEekAsG2QT

I've tested a patch identical to this on my Thinkpad T430s and it
seems to work quite well for me.

				- Ted
