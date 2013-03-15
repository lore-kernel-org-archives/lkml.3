Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3COT5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:57:23 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34059 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3COT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:57:21 -0400
Date: Fri, 15 Mar 2013 12:57:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon fixes for 3.9-rc3
Message-ID: <20130315195718.GA27736@kroah.com>
References: <51410B25.907@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51410B25.907@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 08:26:29AM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> This is extcon fixes for 3.9-rc3.
> Please pull extcon with following updates.
> 
> Best Regards,
> Chanwoo Choi
> 
> The following changes since commit
> f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
> 
>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git
> tags/extcon-3.9-rc3
> 
> for you to fetch changes up to 0ec83bd2460ed6aed0e7f29f9e0633b054621c02:
> 
>   extcon: max77693: Initialize register of MUIC device to bring up
> it without platform data (2013-03-13 17:38:57 +0900)
> 
> ----------------------------------------------------------------
> extcon fixes for 3.9-rc3
> 
> This is small fixes against 3.9-rc2.
> 
> Fix to max77693 extcon driver:
> - Set default value of MUIC register to bring up it.
> Fix to max8997 extcon driver:
> - Fix null pointer error duing probe when platform data
> isn't used.
> 
> ----------------------------------------------------------------
> Chanwoo Choi (3):
>       extcon: max8997: Check the pointer of platform data to protect
> null pointer error
>       extcon: max77693: Fix bug of wrong pointer when platform data
> is not used
>       extcon: max77693: Initialize register of MUIC device to bring
> up it without platform data
> 
>  drivers/extcon/extcon-max77693.c     | 103
> +++++++++++++++++++++++++++--------
>  drivers/extcon/extcon-max8997.c      |  56 +++++++++++--------
>  include/linux/mfd/max77693-private.h |  23 ++++++++
>  3 files changed, 137 insertions(+), 45 deletions(-)

I've pulled and pushed out, but note your emails are still getting
line-wrapped, which is a pain...

greg k-h
