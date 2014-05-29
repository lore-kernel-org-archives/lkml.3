Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaE2XZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:25:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33278 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbaE2XZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:25:38 -0400
X-Sasl-enc: kr/cMH8RKitEcxSrmQXiIYOqyOL8OJS4i0EdwkY5Bl5z 1401405936
Date: Thu, 29 May 2014 16:25:34 -0700
From: Greg KH <greg@kroah.com>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, m@bues.ch,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-wireless@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-samsungsoc@vger.kernel.org,
        spear-devel@list.st.com, platform-driver-x86@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] gpio: removes all usage of gpiochip_remove retval
Message-ID: <20140529232534.GA11741@kroah.com>
References: <1401400492-26175-1-git-send-email-berthe.ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401400492-26175-1-git-send-email-berthe.ab@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:54:52PM +0200, abdoulaye berthe wrote:
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>

Why?
