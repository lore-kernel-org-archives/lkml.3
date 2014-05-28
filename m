Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaE1XcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:32:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaE1Xb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:31:59 -0400
Date: Wed, 28 May 2014 16:35:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 15/15] misc: atmel_pwm: remove obsolete driver
Message-ID: <20140528233534.GA3580@kroah.com>
References: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1401319218-16772-16-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401319218-16772-16-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:20:18AM +0200, Alexandre Belloni wrote:
> The misc/atmel_pwm is not used by any mainlined boards and has been replaced by
> the pwm-driver using the generic PWM framework.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

