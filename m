Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604Ab3DHCga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 22:36:30 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:63033 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459Ab3DHCg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:36:29 -0400
Date: Sun, 7 Apr 2013 19:36:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon fixes for 3.9-rc6
Message-ID: <20130408023621.GA5894@kroah.com>
References: <51622526.8000302@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51622526.8000302@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:02:14AM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> This is extcon fixes for 3.9-rc6
> Please pull extcon with following updates.
> 
> Best Regards and thanks,
> Chanwoo Choi
> 
> The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:
> 
>   Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-3.9-rc6
> 
> for you to fetch changes up to 2fbeb4347e02078828510e5fe43ab4bea21b20d1:
> 
>   extcon: max8997: Fix return value (2013-04-08 09:13:18 +0900)
> 
> ----------------------------------------------------------------
> This is small fixes for extcon driver.
> 
> MAX77693 extcon driver
> - Add 'static' keryword to internal data structure
> - Fix return value using 'ret' instead of hardcoding
> 
> MAX8997 extcon driver
> - Use dev_err() instead of pr_err()
> - Fix return value using 'ret' instead of hardcoding

None of these should go into 3.9-final, they are all trivial cleanups.
Only major bug fixes or regressions should be sent right now for 3.9,
sorry.

I will be glad to pull these into my -next branch for 3.10 if you want.

greg k-h
