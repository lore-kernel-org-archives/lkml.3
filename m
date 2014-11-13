Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaKMMen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:34:43 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:33512 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbaKMMem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:34:42 -0500
Date: Thu, 13 Nov 2014 13:24:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org, libc-alpha@sourceware.org
Subject: Impact of removing VM_EXEC from brk area
Message-ID: <20141113122406.GA19763@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch to remove VM_EXEC from VM_DATA_DEFAULT_FLAGS for MIPS has been
submitted to me with the primary motivation for this change being
some performance improvment.  In other words, the patch would remove
execute permission from a process brk area.  It's however unclear to
me how much software wreckage would result from such a change, even
if the execute permission for the stack area remains unchanged.

So, what would break?

Thanks,

  Ralf
