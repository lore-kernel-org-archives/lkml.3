Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaIAPPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:15:39 -0400
Received: from verein.lst.de ([213.95.11.211]:57163 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbaIAPPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:15:38 -0400
Date: Mon, 1 Sep 2014 17:15:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] scsi/trace: Use macros for getting driver byte,
	host byte, msg byte, and status byte
Message-ID: <20140901151531.GA5136@lst.de>
References: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal> <20140901123327.597.39622.stgit@yuno-kbuild.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901123327.597.39622.stgit@yuno-kbuild.novalocal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:33:28PM +0000, Yoshihiro YUNOMAE wrote:
> For getting driver byte, host byte, msg byte, and status byte, macros are
> implemented in scsi/scsi.h, so we use it.

As mentioned about three times in various previous scsi logging discussions
this is entirely wrong and breaks decoding binary trace buffers.

NAK.

