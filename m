Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3LMRaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:30:00 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55175 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3LMR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131213163733.GF20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-4-git-send-email-zwu.kernel@gmail.com>
	<20131213163733.GF20803@infradead.org>
Date: Sat, 14 Dec 2013 01:29:58 +0800
Message-ID: <CAEH94LhEvFff8rcfrbM1_xM4e=2H1083Jb194zYA6ERZcqDe+Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] xfs: add xfs_create_tmpfile() for O_TMPFILE support
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed them, thanks.

On Sat, Dec 14, 2013 at 12:37 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +     error = xfs_dir_ialloc(&tp, NULL, mode, 0, rdev,
>
> please pass the parent inode pointer here.
>
>> +                             XFS_PROJID_DEFAULT, resblks > 0,
>
> and pass the project id that you inherited from the parent here.
>



-- 
Regards,

Zhi Yong Wu
