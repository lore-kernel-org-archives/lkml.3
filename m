Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaH3Uo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:44:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaH3Uoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:44:55 -0400
Date: Sat, 30 Aug 2014 13:44:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navin.patidar@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 03/20] staging: rtl8188eu: Rework function
 PHY_QueryBBReg()
Message-ID: <20140830204454.GA22900@kroah.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
 <1408803521-13715-3-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408803521-13715-3-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 07:48:24PM +0530, navin patidar wrote:
> Rename CamelCase variables and function name.
> 
> Signed-off-by: navin patidar <navin.patidar@gmail.com>

This patch fails to apply:

checking file drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
checking file drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
checking file drivers/staging/rtl8188eu/hal/odm.c
checking file drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
checking file drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
checking file drivers/staging/rtl8188eu/hal/usb_halinit.c
checking file drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
checking file drivers/staging/rtl8188eu/include/phy.h
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED

Can you please refresh it against my staging-next branch of the
staging.git tree on git.kernel.org and resend it, and the rest of the
patches in this series so that I can apply them?

thanks,

greg k-h
