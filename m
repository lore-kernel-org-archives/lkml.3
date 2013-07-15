Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab3GOUpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:45:55 -0400
Received: from mail.tpi.com ([74.45.170.26]:3110 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab3GOUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:45:53 -0400
X-Greylist: delayed 1361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 16:45:53 EDT
Message-ID: <51E45A30.2050803@canonical.com>
Date: Mon, 15 Jul 2013 14:23:12 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eli Cohen <eli@mellanox.com>
Subject: Re: [PATCH 3.11-rc1] mlx5 core: Fix __udivdi3 when compiling for
 32 bit arches
References: <1373900205-69711-1-git-send-email-tim.gardner@canonical.com> <51E41AB2.3020905@infradead.org>
In-Reply-To: <51E41AB2.3020905@infradead.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 09:52 AM, Randy Dunlap wrote:
> On 07/15/13 07:56, Tim Gardner wrote:
>> Cc: Eli Cohen <eli@mellanox.com> Signed-off-by: Tim Gardner
>> <tim.gardner@canonical.com>
> 
> I reported this last week and Eli wrote:
> 
> "I have this fixed in my tree and we run the driver on i386. I will
> check on Sunday why it is not in the patches submitted."
> 
> Anyway, the patch works for me.
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org> Reported-by: Randy
> Dunlap <rdunlap@infradead.org>
> 

I figured someone must have seen it, but a cursory Google search on
"mlx5 __udivdi3" failed to turn up anything.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
