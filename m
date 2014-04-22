Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaDVKL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:11:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35648 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaDVKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:11:20 -0400
Date: Tue, 22 Apr 2014 13:11:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] staging: rtl8188eu: Remove _ReadLEDSetting()
 function.
Message-ID: <20140422101101.GG26890@mwanda>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
 <1397983638-10752-3-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397983638-10752-3-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 02:17:11PM +0530, navin patidar wrote:
> _ReadLEDSetting() doesn't read led settings this function actually
> initialize  member variables of struct led_priv, we should do that
> inside rtl8188eu_InitSwLeds().
> 

This seems like a bugfix or is it just a cleanup?  It's not clear to me
from the patch description.  Have you tested this patch?

regards,
dan carpenter

