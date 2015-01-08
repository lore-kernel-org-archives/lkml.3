Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbbAHUb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:31:59 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:51409 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbAHUb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:31:58 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 8 Jan 2015 12:31:36 -0800
Message-ID: <CAADnVQ+U5=DD555UqYM1gUQxWLE4qN=Xz1kJVHp=Zxmz3Z_ZJQ@mail.gmail.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>,
        bvanassche <bvanassche@acm.org>, hare <hare@suse.de>,
        jbottomley <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 1:29 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Jan 07, 2015 at 07:55:42PM -0800, Alexei Starovoitov wrote:
>> I'm seeing the same splats... what tree I can pull the fix from ?
>
> None so far.  I'll still need a review to apply it to the scsi-queue tree.

applied it manually and warning is gone. It used to
spam a lot of them.
