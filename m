Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab3HNVdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:33:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25731 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab3HNVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:33:17 -0400
Date: Thu, 15 Aug 2013 00:31:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Rupesh Gujare <rupesh.gujare@atmel.com>, devel@linuxdriverproject.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 07/10] staging: ozwpan: Make oz_hcd_pd_departed() take a
 struct pointer.
Message-ID: <20130814213155.GH4713@mwanda>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
 <1376414966-23525-3-git-send-email-rupesh.gujare@atmel.com>
 <520A6E5B.3020303@cogentembedded.com>
 <520A6F75.8010308@atmel.com>
 <520A70FC.6080003@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A70FC.6080003@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 09:46:36PM +0400, Sergei Shtylyov wrote:
> 
> >>   Do you really need a copy? Isn't it better to rename the parameter and
> >>remove this line altogether?
> 
> >>WBR, Sergei
> 
> >Yes, that is the idea,  for next patch series, as I don't want to mix two
> >changes in single patch.
> 
>    Don't think it's worth another series.
> 

Yeah, it should have been done in the same patch, you're obviously
right.  But Greg already merged them so it will have to be fixed in
follow on patches.

regards,
dan carpenter
