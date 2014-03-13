Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaCMJ4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:56:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39967 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753598AbaCMJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:56:13 -0400
Date: Thu, 13 Mar 2014 10:56:11 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: add initial support for the Marvell BG2-Q DMP
Message-ID: <20140313095611.GA3036@piout.net>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140312113523.GL13905@piout.net>
 <53217FA1.4020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53217FA1.4020903@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13/03/2014 at 09:51:29 +0000, Sebastian Hesselbarth wrote :
> thanks for posting this. I also prefer each patch to have a commit log
> no matter how obvious the contents may be. Please have a simple commit
> log for each of the single patches.
> 
> You can leave out the link to marvell.com in the commit log as you
> update Marvell SoC documentation.
> 
> TBH, I haven't set up any mach-berlin branches, yet. Also it is very
> late in the cycle. I'll setup proper branches and also a -next branch
> for next release, maybe we can take your DT patches directly through
> arm-soc this time. Otherwise, we'll have to postpone them for v3.16.
> 

We were aiming at 3.16 anyway. No worries.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
