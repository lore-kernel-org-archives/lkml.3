Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3J2TQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:16:34 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:42031 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3J2TQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:16:32 -0400
Date: Tue, 29 Oct 2013 15:16:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux IDE/ATA Dev <linux-ide@vger.kernel.org>
Subject: Re: [PATCH trivial v2] ata: libata-eh: Remove unnecessary snprintf
 arithmetic
Message-ID: <20131029191627.GB22261@mtj.dyndns.org>
References: <5270061A.3080108@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5270061A.3080108@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:01:46PM +0100, Levente Kurusa wrote:
> Remove an unnecessary arithmetic operation from a call to snprintf, because
> the size parameter of snprintf includes the trailing null space.
> Also, initialize the buffer on definition instead of a memset call.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

Applied to libata/for-3.13.

Thanks.

-- 
tejun
