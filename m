Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBNWAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:00:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaBNWAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:00:54 -0500
Date: Sat, 15 Feb 2014 01:00:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] [RFC] staging: rtl8821ae: fix invalid bit mask on MSR_AP
 check
Message-ID: <20140214220041.GD26722@mwanda>
References: <1392414623-4369-1-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392414623-4369-1-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 10:50:23PM +0100, Levente Kurusa wrote:
> Since MSR_AP is 0x3, ANDing it with 0xFC will never be true.
> Add a NOT operation to 0xFC so that we will AND with the last
> three bits which will result in a possibility that the condition
> will succeed.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
> ---
>  Hi,
> 
>  This might not be the real solution since it is also possible that
>  the particular condition never really happens. I seek comments
>  so that I can post the proper patch.
> 

I can't test it either but I think your fix is correct.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

