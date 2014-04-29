Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaD2HGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:06:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37631 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaD2HGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:06:05 -0400
Date: Tue, 29 Apr 2014 10:05:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: rtl8188eu: Use USB subsystem functions to
 check endpoint type
Message-ID: <20140429070553.GX26890@mwanda>
References: <1398734713-4367-1-git-send-email-navin.patidar@gmail.com>
 <1398734713-4367-2-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398734713-4367-2-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 06:55:13AM +0530, navin patidar wrote:
> Use inline functions provided by USB subsystem to check endpoint type,
> instead of inline functions implemented by driver to do the same.
> 
> Signed-off-by: navin patidar <navin.patidar@gmail.com>

Looks nice.  Thanks.  :)

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


