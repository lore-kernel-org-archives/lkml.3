Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaIBGD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:03:28 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34084 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaIBGD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:03:26 -0400
X-AuditID: 85900ec0-cff26b9000001514-26-54055dab542f
Message-ID: <54055DAB.2050103@hitachi.com>
Date: Tue, 02 Sep 2014 15:03:23 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Re: [PATCH 1/3] scsi/trace: Use macros for getting driver
 byte, host byte, msg byte, and status byte
References: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal> <20140901123327.597.39622.stgit@yuno-kbuild.novalocal> <20140901151531.GA5136@lst.de>
In-Reply-To: <20140901151531.GA5136@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/02 0:15), Christoph Hellwig wrote:
> On Mon, Sep 01, 2014 at 12:33:28PM +0000, Yoshihiro YUNOMAE wrote:
>> For getting driver byte, host byte, msg byte, and status byte, macros are
>> implemented in scsi/scsi.h, so we use it.
>
> As mentioned about three times in various previous scsi logging discussions
> this is entirely wrong and breaks decoding binary trace buffers.

No, this patch uses just macros, so this does not change decoders.
However, other patches change decoders in format files, so we need to
consider about these decoders more, as you say.
We'll discuss on https://lkml.org/lkml/2014/8/28/657.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


