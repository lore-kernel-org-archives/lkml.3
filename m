Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab3B1WMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:12:34 -0500
Received: from mout.gmx.net ([212.227.15.18]:65459 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760116Ab3B1WM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:12:29 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19X3Ug+MQJX0bOVaBmjVKPaj4WC7PFajEQFNK4r/L
	t4ZAroH7JQxdHm
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH RESEND] char/tpm: Convert struct i2c_msg initialization to C99 format
Date: Thu, 28 Feb 2013 23:12:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.7; KDE/4.9.5; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Kent Yoder <key@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20130228110611.3ed77e92@endymion.delvare>
In-Reply-To: <20130228110611.3ed77e92@endymion.delvare>
MIME-Version: 1.0
Message-Id: <201302282312.51514.PeterHuewe@gmx.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for resending.


Am Donnerstag, 28. Februar 2013, 11:06:11 schrieb Jean Delvare:
> From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
> 
> Convert the struct i2c_msg initialization to C99 format. This makes
> maintaining and editing the code simpler. Also helps once other fields
> like transferred are added in future.
> 
> Thanks to Julia Lawall for automating the conversion.
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Peter Huewe <peter.huewe@infineon.com>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> v2: removed zero initialization of flags.
> 
> Patch already sent by Shubhrajyoti Datta on 2012-10-10.
> 
>  drivers/char/tpm/tpm_i2c_infineon.c |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)

As it was not yet applied I folded it into my patch
"Add support for new Infineon I2C TPM (SLB 9645 TT 1.2 I2C)"


Thanks,
Peter
