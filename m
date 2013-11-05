Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3KENxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:53:37 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:52712 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3KENxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:53:35 -0500
X-ASG-Debug-ID: 1383659614-0421b57ae67d790001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Tue, 5 Nov 2013 08:53:33 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Kent Overstreet <kmo@daterainc.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <axboe@kernel.dk>, <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <chris.mason@fusionio.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 1/9] block: Convert various code to bio_for_each_segment()
Message-ID: <20131105135333.GB27784@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH 1/9] block: Convert various code to bio_for_each_segment()
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
 <1383608187-27368-2-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383608187-27368-2-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1383659614
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142073
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 03:36:19PM -0800, Kent Overstreet wrote:
> With immutable biovecs we don't want code accessing bi_io_vec directly -
> the uses this patch changes weren't incorrect since they all own the
> bio, but it makes the code harder to audit for no good reason - also,
> this will help with multipage bvecs later.
> 

The btrfs parts of this look good to me, you can add

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks for this,

Josef
