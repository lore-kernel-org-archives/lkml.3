Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaHWAbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:31:07 -0400
Received: from verein.lst.de ([213.95.11.211]:37361 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbaHWAbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:31:05 -0400
Date: Sat, 23 Aug 2014 02:31:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][SCSI] fix regression in SCSI_IOCTL_SEND_COMMAND
Message-ID: <20140823003100.GA16302@lst.de>
References: <53F79FBF.4090000@cybernetics.com> <53F7E02B.4070606@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F7E02B.4070606@interlog.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 08:28:27PM -0400, Douglas Gilbert wrote:
> To test this ioctl one option is to get the sg3_utils
> package and build scsi_ioctl.c in the examples
> directory with 'make scsi_ioctl'.
>
> In lk 3.17-rc1, scsi_ioctl indicates that
> SCSI_IOCTL_SEND_COMMAND is not working. In my test applying
> this patch fixes the regression.

Is there any amount of chocolate or beer that could trick you into adding an
automated regression test suite to sg3_utils that could be used to
automatically check for regressions like this?

