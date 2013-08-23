Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3HWTTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:19:50 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:62931 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3HWTTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:19:49 -0400
Date: Fri, 23 Aug 2013 15:19:47 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Message-ID: <1033284781.908504.1377285587778.JavaMail.root@mail>
In-Reply-To: <20130823190247.GA3821@katana>
Subject: Re: [PATCH] misc: (at24) move header to linux/platform_data/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC28 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram wrote:

> On Fri, Aug 23, 2013 at 02:38:20PM -0400, Vivien Didelot wrote:
> > This patch moves the at24.h header from include/linux/i2c to
> > include/linux/platform_data and updates existing support
> > accordingly.
> 
> This message explains what the patch does but not why the change is
> wanted. I'd be surprised if we really want *all* platform_data in one
> single directory?

IMHO it makes sense. Why wouldn't we want all platform_data in
include/linux/platform_data/?

> Is this patch part of a bigger series?
No.

> That being said i2c is not the best place for this include, in deed...
I agree.

Thanks,
Vivien
