Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab3GSXF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:05:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37370 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3GSXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:05:55 -0400
Date: Fri, 19 Jul 2013 16:05:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal.mostafa@canonical.com>, rydberg@euromail.se,
        kendatsuba@gmail.com, linux-input@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [PATCH][v3.2.y][v3.5.y][3.8.y] Input: elantech - fix for newer
 hardware versions (v7)
Message-ID: <20130719230550.GA19715@core.coreip.homeip.net>
References: <51E9B4A1.3080205@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E9B4A1.3080205@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

On Fri, Jul 19, 2013 at 05:50:25PM -0400, Joseph Salisbury wrote:
> Hello,
> 
> Please consider including upstream commit
> 9eebed7de660c0b5ab129a9de4f89d20b60de68c in the next v3.2.y, v3.5.y and
> v3.8.y releases. 
> 
> It was included upstream as of v3.11-rc1.  It has been tested and
> confirmed to resolve http://bugs.launchpad.net/bugs/1166442 .
> 
> commit 9eebed7de660c0b5ab129a9de4f89d20b60de68c
> Author: Matteo Delfino <kendatsuba@gmail.com>
> Date:   Sat Jul 6 21:52:26 2013 -0700
> 
>     Input: elantech - fix for newer hardware versions (v7)
> 
> 

This fix came into my mailbox on July 06, so fairly recently. I would
prefer if we went through a few more -rcs before sending it to stable.

Thanks.

-- 
Dmitry
