Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaDCJjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:39:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47203 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaDCJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:39:06 -0400
Date: Thu, 3 Apr 2014 12:38:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sherif <shehabaldin.sherif@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 7/9] driver: staging: wlan-ng: Fixed white spaces issues
Message-ID: <20140403093855.GG6991@mwanda>
References: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com>
 <20140403074511.GY6991@mwanda>
 <533D1A01.30304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D1A01.30304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 10:21:21AM +0200, Sherif wrote:
> Yes I see the error. I have tried to build the wlan-ng driver using
> make M=drivers/staging/wlan-ng/ but it built nothing, so I went one
> step up and built make M=drivers/staging/ as a whole and it built
> fine, I think I am missing something here, how do I specify this
> module for the build to test my changes?
> 

Is it enabled in your .config?

grep PRISM2_USB .config

regards,
dan carpenter

