Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaEKLrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 07:47:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55799 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950AbaEKLry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 07:47:54 -0400
Message-ID: <536F6363.7060007@gmail.com>
Date: Sun, 11 May 2014 17:17:47 +0530
From: Paul Davies C <pauldaviesc@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/3] Enclose complex macro with parantheses in staging/octeon-usb/octeon-hcd.c
References: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com> <1399795703-6681-3-git-send-email-pauldaviesc@gmail.com> <20140511105546.GC6670@drone.musicnaut.iki.fi>
In-Reply-To: <20140511105546.GC6670@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 May 2014 04:25 PM, Aaro Koskinen wrote:
> Hi,
>
> On Sun, May 11, 2014 at 01:38:22PM +0530, Paul Davies C wrote:
>> Complex macro is enlosed with parantheses.
> This patch breaks compilation. I'll send patches to remove the whole macro.
>
> A.
I hope everything else is ok with you. I will drop PATCH 2/3 and 
resubmit it.

-- 
Paul Davies C,
CSE B.Tech. student,
Govt. Engineering College, Thrissur.

