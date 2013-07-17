Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3GQT7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:59:14 -0400
Received: from mail.tpi.com ([74.45.170.26]:3222 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3GQT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:59:13 -0400
X-Greylist: delayed 1732 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 15:59:13 EDT
Message-ID: <51E6F0CE.2080205@gmail.com>
Date: Wed, 17 Jul 2013 13:30:22 -0600
From: Tim Gardner <rtg.canonical@gmail.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.11.0-rc1:  Mellanox mlx5 fails to compile on 32-bit kernels
References: <51E6E77A.6030901@candelatech.com>
In-Reply-To: <51E6E77A.6030901@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 12:50 PM, Ben Greear wrote:
> Seems there is a 64-bit division in there somewhere.
> 
> Thanks,
> Ben
> 

http://www.gossamer-threads.com/lists/linux/kernel/1746720

-- 
Tim Gardner tim.gardner@canonical.com
