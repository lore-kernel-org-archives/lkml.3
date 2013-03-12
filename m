Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3CLIjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:39:12 -0400
Received: from www.humilis.net ([82.95.169.224]:56177 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab3CLIjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:39:10 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 04:39:10 EDT
Date: Tue, 12 Mar 2013 09:28:54 +0100
From: Sander <sander@humilis.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130312082854.GA1515@panda>
Reply-To: sander@humilis.net
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311204625.GA433@x4>
X-Uptime: 08:37:15 up 26 days, 13:37, 35 users,  load average: 0.01, 0.04,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote (ao):
> On 2013.03.11 at 16:37 -0400, Theodore Ts'o wrote:
> > We actually run fsx in a number of different configruations as part of
> > our regression testing before we send Linus a pull request, and
> > haven't found any issues.  So unless it's a hardware problem, it seems
> > unlikely to me that your running fsx would turn up anything.
> 
> Yes, I let it run for a while anyway and it didn't report any failure.

> Please note that my local rtorrent version was configured with
> "--with-posix-fallocate".

Would it be possible to enhance fsx to detect such an issue?

	Sander
