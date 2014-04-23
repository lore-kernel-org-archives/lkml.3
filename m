Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbaDWTBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:01:16 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60175 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbaDWTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:01:12 -0400
Date: Wed, 23 Apr 2014 15:01:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: Re: [PATCH] s390/ccwgroup: Fix memory corruption
Message-ID: <20140423190108.GC4163@mtj.dyndns.org>
References: <1398279525-2837-1-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398279525-2837-1-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 08:58:45PM +0200, Christian Borntraeger wrote:
> commit 0b60f9ead5d4816e7e3d6e28f4a0d22d4a1b2513 (s390: use
> device_remove_file_self() instead of device_schedule_callback())
> 
> caused random memory corruption on my s390 box. Turns out that the
> last element of the ccwgroup structure is of dynamic size, so we
> must move the newly introduced work structure _before_ the zero
> length array.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> CC: Sebastian Ott <sebott@linux.vnet.ibm.com>
> CC: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Oops,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
