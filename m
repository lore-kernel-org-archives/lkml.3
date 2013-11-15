Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3KONIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:08:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32262 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3KONIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:08:46 -0500
Date: Fri, 15 Nov 2013 16:08:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yu-Chen Cho <acho@suse.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] Staging: btmtk_usb: Add hdev parameter to hdev->send
 driver callback
Message-ID: <20131115130820.GS5302@mwanda>
References: <1384517231-1605-1-git-send-email-geert@linux-m68k.org>
 <D32EAC93-D2DE-431C-9DCB-885C5AA10A3A@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D32EAC93-D2DE-431C-9DCB-885C5AA10A3A@holtmann.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:30:04PM +0900, Marcel Holtmann wrote:
> 
> while this is patch is correct, I do not really care about staging drivers that actually bluntly violate my copyright.
> 

That's very cryptic.

What is going on here?  I googled it and I wasn't able to find what you
are talking about.  Care to give us a hint and what you want us to do
here?

I have also added Johan Hedberg to the CC list because he also helped
break the build.  Don't do that.

regards,
dan carpenter

