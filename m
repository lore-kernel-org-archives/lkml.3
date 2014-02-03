Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBCUMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:12:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40111 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBCUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:12:49 -0500
Date: Mon, 3 Feb 2014 23:12:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Andrea Merello <andrea.merello@gmail.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: rtl8821ae.
Message-ID: <20140203201228.GE26722@mwanda>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
 <20140202160512.GA4946@redhat.com>
 <201402021807.37772.s.L-H@gmx.de>
 <52EFCC66.9020304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EFCC66.9020304@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 11:05:42AM -0600, Larry Finger wrote:
> A combined driver would require very many branches based on chip
> number and would certainly execute much more slowly.

I seriously doubt there are performance issues with merging the drivers.

regards,
dan carpenter

