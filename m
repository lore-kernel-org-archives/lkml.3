Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3AOLhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:37:19 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48333 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3AOLhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:37:17 -0500
Date: Tue, 15 Jan 2013 03:38:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, rtc-linux@googlegroups.com
Subject: Re: rtc: vt8500: Fix year field in vt8500_rtc_set_time
Message-ID: <20130115113812.GE1748@kroah.com>
References: <1358234563.6868.13.camel@gitbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358234563.6868.13.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 08:22:43PM +1300, Tony Prisk wrote:
> Alessandro,
> 
> This patch was sent out at the same time as two other RTC fixes for
> vt8500 but this one seems to have stopped somewhere along the way while
> the other two have been accepted.
> 
> The patch is showing in the RTC patch system along with the other two:
> http://patchwork.ozlabs.org/patch/208756/
> 
> 
> Greg,
> How did the first two patches find their way to you - did you pick them
> up off one of the lists?

I have no idea, normally rtc patches go through Andrew Morton.

