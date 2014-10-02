Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaJBMqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:46:24 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53264 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbaJBMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:46:22 -0400
X-Sasl-enc: EhE1gMQk1mxvB02FC6obN50WbfzXGNB1++8ggwvjKVyv 1412253981
Date: Thu, 2 Oct 2014 05:45:24 -0700
From: Greg KH <greg@kroah.com>
To: Amber Thrall <amber.rose.thrall@gmail.com>
Cc: jarod@wilsonet.com, m.chehab@samsung.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
Message-ID: <20141002124524.GA25203@kroah.com>
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 09:40:02PM -0700, Amber Thrall wrote:
> Fixed various coding style issues, including strings over 80 characters long and many 
> deprecated printk's have been replaced with proper methods.

Only do one thing per patch, you are doing lots of different things
here, and as Dan pointed out, you broke the build.

greg k-h
