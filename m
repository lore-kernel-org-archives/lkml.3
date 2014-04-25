Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaDYJw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:52:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24824 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaDYJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:52:55 -0400
Date: Fri, 25 Apr 2014 12:52:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rogerable@realtek.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, Oliver Neukum <oneukum@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v7 4/4] memstick: Add realtek USB memstick host driver
Message-ID: <20140425095217.GI26890@mwanda>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
 <1397199203-2235-5-git-send-email-rogerable@realtek.com>
 <20140416081352.GA4754@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416081352.GA4754@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:13:52AM +0100, Lee Jones wrote:
> It seems Max and Alex are less than interested in this patch, so I'm
> going to apply it anyway. In your last review you mentioned that it
> looked good to your inexpert eye. Can I apply your Ack to that effect?
> 

Just apply it...  He said it was ok.

These two new drivers are not beautiful works of art but they're not
horrible.

Roger and the Realtek devs have been very responsive so I imagine
they'll fix which ever bugs show up.  Let's move on with this.

regards,
dan carpenter

