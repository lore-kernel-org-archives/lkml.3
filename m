Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3B1Wc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:32:57 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:13617 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3B1Wcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:32:54 -0500
Date: Thu, 28 Feb 2013 23:32:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter =?UTF-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH RESEND] char/tpm: Convert struct i2c_msg
 initialization to C99 format
Message-ID: <20130228233235.5f279117@endymion.delvare>
In-Reply-To: <201302282312.51514.PeterHuewe@gmx.de>
References: <20130228110611.3ed77e92@endymion.delvare>
	<201302282312.51514.PeterHuewe@gmx.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013 23:12:51 +0100, Peter Hüwe wrote:
> thanks for resending.

You're welcome.

> Am Donnerstag, 28. Februar 2013, 11:06:11 schrieb Jean Delvare:
> > From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
> > 
> > Convert the struct i2c_msg initialization to C99 format. This makes
> > maintaining and editing the code simpler. Also helps once other fields
> > like transferred are added in future.
> > 
> > Thanks to Julia Lawall for automating the conversion.
> > 
> > Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > Acked-by: Peter Huewe <peter.huewe@infineon.com>
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> > v2: removed zero initialization of flags.
> > 
> > Patch already sent by Shubhrajyoti Datta on 2012-10-10.
> > 
> >  drivers/char/tpm/tpm_i2c_infineon.c |   19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> As it was not yet applied I folded it into my patch
> "Add support for new Infineon I2C TPM (SLB 9645 TT 1.2 I2C)"

I'd suggest not to. Mixing actual changes with cleanups is generally
discouraged.

-- 
Jean Delvare
