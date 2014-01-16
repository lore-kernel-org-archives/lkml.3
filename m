Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaAPGMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:12:45 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:36858 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAPGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:12:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140115.215753.1619877365795484712.davem@davemloft.net>
References: <52D75F1D.9040405@oracle.com>
	<20140115.215753.1619877365795484712.davem@davemloft.net>
Date: Thu, 16 Jan 2014 14:12:42 +0800
Message-ID: <CABawtvM0syVF2E3f8kEad9hebh96BeE0YEQ6yJWQS7Nvy8NQvg@mail.gmail.com>
Subject: Re: [PATCH 1/2 Net-next] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro
 and cleanup const 63
From: Ethan Zhao <ethan.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ethan zhao <ethan.zhao@oracle.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
   Sorry about the signoffs, I am confused about how to sign the patch,
If I sign it with off-work mail address, some of it is done within work-hours,
maybe that why I sign if with both personal mail address and work one.
If that bother you, just remove it.

Thanks,
Ethan

On Thu, Jan 16, 2014 at 1:57 PM, David Miller <davem@davemloft.net> wrote:
> From: ethan zhao <ethan.zhao@oracle.com>
> Date: Thu, 16 Jan 2014 12:25:01 +0800
>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>
> Please don't give two signoffs for yourself, it is not appropriate at
> all.
>
> I am very genuinely curious where you got the idea to do that,
> particularly as I've never seen anyone else do it before.  So it's
> really not possible that you got the idea from someone else's actions.
