Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaJ2IY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:24:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51851 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbaJ2IYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:24:24 -0400
Date: Wed, 29 Oct 2014 09:24:29 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <khilman@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/3] i2c/at91: add support PM functions
Message-ID: <20141029082429.GG9284@ldesroches-Latitude-E6320>
Mail-Followup-To: Wenyou Yang <wenyou.yang@atmel.com>, wsa@the-dreams.de,
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
	nicolas.ferre@atmel.com, khilman@kernel.org,
	linux-arm-kernel@lists.infradead.org
References: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the whole serie

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

On Fri, Oct 24, 2014 at 02:50:14PM +0800, Wenyou Yang wrote:
> Hi Wolfram,
> 
> The patches is to add the PM functions support for the at91 i2c controller.
> 
> It is based on the i2c/for-next branch of 
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git.
> 
> Best Regards,
> Wenyou Yang
> 
> ------
> Change log:
> v2.0
> 
> According to the advice from Kevin Hilman, 
> 1./ Wrap the runtime suspend/resume functions in CONFIG_PM instead of CONFIG_PM_RUNTIME.
> 2./ Call the runtime suspend/resume functions directly in the system suspend/resume.
> 
> v3.0
>    Covert the system suspend/resume to suspend_noirq/resume_noirq.
> 
> Wenyou Yang (3):
>   i2c/at91: add support for runtime PM
>   i2c/at91: add support for system PM
>   i2c/at91: adopt pinctrl support
> 
>  drivers/i2c/busses/i2c-at91.c |   71 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 65 insertions(+), 6 deletions(-)
> 
> -- 
> 1.7.9.5
> 
