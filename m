Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaKDAFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:05:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKDAFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:05:44 -0500
Date: Mon, 3 Nov 2014 16:05:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chen Weixiang <weixiangchen@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that '=',
 '<' and '=='
Message-ID: <20141104000543.GA17516@kroah.com>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:47:22AM +0800, Chen Weixiang wrote:
> Remove following code style errors from ft1000/ft1000-usb/ft1000_debug.c
> and ft1000/ft1000-pcmcia/ft1000_hw.c:
> ERROR: spaces required around that '=' (ctx:VxV)
> ERROR: spaces required around that '<' (ctx:VxV)
> ERROR: spaces required around that '==' (ctx:VxV)
> 
> Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |  6 ++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 28 ++++++++++++------------
>  2 files changed, 17 insertions(+), 17 deletions(-)

This patch doesn't apply against my staging.git tree on git.kernel.org
Please refresh the series against the staging-testing and resend.

thanks,

greg k-h
