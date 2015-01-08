Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbbAHOBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:01:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50203 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbbAHOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:01:19 -0500
Date: Thu, 8 Jan 2015 17:01:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: simon <wei.guo.simon@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc3 1/1] STAGING: Fix pcl818.c coding style issue
Message-ID: <20150108140116.GM15033@mwanda>
References: <20150108100750.GA2437@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108100750.GA2437@thunderCat>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 06:07:50PM +0800, simon wrote:
>  Correct coding style problem in pcl818.c. The coding style problems(29 warnings detected by checkpatch.pl) includes:
>   - line over 80 characters
>   - There is space before tabs
>  The changed file has been verified with checkpatch.pl to be clean for warnings/errors.
> 
>  Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>

Fix your email client From header so it says "Simon Guo" instead of
"simon".  Don't indent your changelog by one space.  Line wrap your
changelog at 72 characters.

regards,
dan carpenter

