Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3HTVix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:38:53 -0400
Received: from verein.lst.de ([213.95.11.211]:60054 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab3HTViw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:38:52 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 17:38:51 EDT
Date: Tue, 20 Aug 2013 23:29:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/9] target: Add support for COMPARE_AND_WRITE (VAAI)
	emulation
Message-ID: <20130820212912.GA9483@lst.de>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:07:51PM +0000, Nicholas A. Bellinger wrote:
> 
> It's also currently lacking the necessary sychronization between I/O
> submission of COMPARE_AND_WRITE verify instance and write instance
> user data, which is still being worked on in order to avoid additional
> overhead in the main I/O fast path.

I don't think merging such a non-conforming implementation makes any sense.

Also for a complex command like this with all it's race potential I would
really like to see some test cases to go along with it.

