Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3LFR3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:29:37 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50354 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3LFR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:29:35 -0500
Date: Fri, 6 Dec 2013 09:29:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: David Miller <davem@davemloft.net>
Cc: zwu.kernel@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [net-next PATCH 3/6] macvtap: remove the dead branch
Message-ID: <20131206172931.GA32730@roeck-us.net>
References: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
 <1386282527-14094-4-git-send-email-zwu.kernel@gmail.com>
 <52A169D4.4060209@roeck-us.net>
 <20131206.114602.2053541753179744731.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206.114602.2053541753179744731.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 11:46:02AM -0500, David Miller wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Thu, 05 Dec 2013 22:08:20 -0800
> 
> > Assigning the function's return value to ret just to ignore it seems
> > odd.
> > 
> > Might make sense to change the function type to void.
> 
> That's exactly what his very next patch does, undoubtedly the two
> patches should be combined into one.
> 
Yes, I think that would be a good idea.

Thanks,
Guenter
