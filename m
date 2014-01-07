Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaAGXeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:34:23 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51525 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaAGXeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:34:13 -0500
Date: Tue, 7 Jan 2014 16:34:10 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Hannes Reinecke <hare@suse.de>
Cc: Ric Wheeler <ricwheeler@gmail.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: status of block-integrity
Message-ID: <20140107233410.GA1263@parisc-linux.org>
References: <20131222192128.GA28532@infradead.org> <yq11u134rmt.fsf@sermon.lab.mkp.net> <52CBBABD.50902@gmail.com> <52CC0216.5060900@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CC0216.5060900@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:33:10PM +0100, Hannes Reinecke wrote:
> I would indeed like to have a discussion at LSF about the future of
> DIX. DIF is not an issue, as most HBAs support it already and we
> actually need it for proper connectivity.
> 
> DIX, OTOH, has been left dormant since time immemorial, with the
> only known (supposed) user being Oracle.
> (I actually talked to the DB/2 folks about it, and the response
> was a polite feigned interest ...)

I think there's a terminology confusion here; you seem to be using DIX
to mean the TCP CRC and DIF to mean T10DIF.  I've seen other people use
DIX to mean separate SGLs for metadata and DIF to mean interleaved data.
Can you confirm which thing you mean here?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
