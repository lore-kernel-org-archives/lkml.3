Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab3BMPyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:54:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34309 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796Ab3BMPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:54:04 -0500
Date: Wed, 13 Feb 2013 07:54:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: cooloney@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] leds-ot200: Fix misbehavior caused by wrong bit masks
Message-ID: <20130213155405.GA2869@kroah.com>
References: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 04:58:30PM +0100, Christian Gmeiner wrote:
> During the development of this driver an in-house register
> documentation was used. The last weeks some integration tests
> were done and this problem was found. It turned out that
> the released register documentation is wrong.
> 
> The fix is very simple: shift all masks by one.
> 
> Our customers can control LEDs from userspace via Java,
> C++ or what every. They have running/working applications where
> they want to control led_3 but led_2 get's used.
> I got a bug report in our in-house bug tracker so it would be
> great to fix this upstream.
> 
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
>  drivers/leds/leds-ot200.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
