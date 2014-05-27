Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaE0Uoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:44:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31662 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaE0Uoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:44:38 -0400
Date: Tue, 27 May 2014 23:43:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/15] staging: rtl8188eu:Remove unused function
 rtl8188eu_set_hw_type()
Message-ID: <20140527204352.GP15585@mwanda>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
 <1401204955-4093-6-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401204955-4093-6-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These would have been easier to review if this patch were folded in with
the previous two patches.  What I look for in these patches is, "Will
the compile break if you get it wrong?"

For "[PATCH 04/15] staging: rtl8188eu:Assign RTL8188E to
padapter->chip_type directly", you could get it wrong and the compile
wouldn't break so I have to go into the code and look at it.

regards,
dan carpenter

