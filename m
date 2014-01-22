Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaAVFU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:20:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35560 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAVFUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:20:55 -0500
Date: Wed, 22 Jan 2014 05:20:53 +0000
From: Joel Becker <jlbec@evilplan.org>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] really large storage sectors - going beyond 4096
 bytes
Message-ID: <20140122052052.GM10565@ZenIV.linux.org.uk>
Mail-Followup-To: Ric Wheeler <rwheeler@redhat.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20131220093022.GV11295@suse.de>
 <52DF353D.6050300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DF353D.6050300@redhat.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
> One topic that has been lurking forever at the edges is the current
> 4k limitation for file system block sizes. Some devices in
> production today and others coming soon have larger sectors and it
> would be interesting to see if it is time to poke at this topic
> again.
> 
> LSF/MM seems to be pretty much the only event of the year that most
> of the key people will be present, so should be a great topic for a
> joint session.

Oh yes, I want in on this.  We handle 4k/16k/64k pages "seamlessly," and
we would want to do the same for larger sectors.  In theory, our code
should handle it with the appropriate defines updated.

Joel

-- 
