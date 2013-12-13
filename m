Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3LMR3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:29:31 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53305 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3LMR33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:29:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131213163230.GE20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-3-git-send-email-zwu.kernel@gmail.com>
	<20131213163230.GE20803@infradead.org>
Date: Sat, 14 Dec 2013 01:29:28 +0800
Message-ID: <CAEH94LhHnFjBif-uGS84EnFqXgoM1fGU+741CH_JSutJ43OWoA@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfs: adjust the interface of xfs_qm_vop_dqalloc()
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

On Sat, Dec 14, 2013 at 12:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 13, 2013 at 10:27:50PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> There may be not a parent inode or a name for O_TMPFILE support, but will pass
>> a struct xfs_mount to xfs_qm_vop_dqalloc(). So its interface need to be
>> adjusted in order that O_TMPFILE creation function can also use it.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> This patch is not actually needed, as we do get passed a parent.
Discarded, thanks.

>



-- 
Regards,

Zhi Yong Wu
