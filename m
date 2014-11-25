Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaKYS5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:57:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48918 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaKYS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:57:35 -0500
Date: Tue, 25 Nov 2014 21:57:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Siddharth Kannan <kannan.siddharth12@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        fanwlexca@gmail.com, rickard_strandqvist@spectrumdigital.se,
        linux-kernel@vger.kernel.org, rashika.kheria@gmail.com,
        ztugcesirin@gmail.com
Subject: Re: [PATCH] staging: bcm: nvm: Fixed spelling errors, that may break
 grep.
Message-ID: <20141125185723.GF4835@mwanda>
References: <1416940098-7491-1-git-send-email-kannan.siddharth12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416940098-7491-1-git-send-email-kannan.siddharth12@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 11:58:18PM +0530, Siddharth Kannan wrote:
> Changing the following:
> 
> Adapater -> Adapter
> STATUS_SUCESS -> STATUS_SUCCESS
> 

The driver you are changing doesn't exist any more.  Work against
linux-next.

regards,
dan carpenter

