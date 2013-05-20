Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab3ETUIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:08:38 -0400
Received: from mout.gmx.net ([212.227.17.21]:50360 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab3ETUIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:08:36 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18DosZqCRMDqpXklC8iOzHez1WKjnUCmZjGSNi3YU
	98FIYxeF6ycpBd
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb/misc/usb3503: Use module_i2c_driver to register driver
Date: Mon, 20 May 2013 22:13:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Dongjin Kim <tobetter@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1369078317-30210-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369078317-30210-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305202213.46282.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Mai 2013, 21:31:57 schrieb Peter Huewe:
> Removing some boilerplate by using module_i2c_driver instead of calling
> register and unregister in the otherwise empty init/exit functions
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
Sorry for the noise 
 already exists in 3.10-rc1 by Lars-Peter Clausen
8244ac0 USB: misc: usb3503: use module_i2c_driver to simplify the code


I was working on an stale tree - sorry.
Please ignore this patch.

Peter

