Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3FFV5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:57:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19570 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:57:40 -0400
Date: Fri, 7 Jun 2013 00:56:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laura Lawniczak <laura.lawniczak@googlemail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>
Subject: Re: [PATCH 1/1] keucr: restored lost line
Message-ID: <20130606215642.GH28112@mwanda>
References: <20130606201631.GB14773@kroah.com>
 <1370551851-13456-1-git-send-email-laura.lawniczak@googlemail.com>
 <1370551851-13456-2-git-send-email-laura.lawniczak@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370551851-13456-2-git-send-email-laura.lawniczak@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:50:51PM +0200, Laura Lawniczak wrote:
> This line was unfortunately removed during patch process. This caused an
> "unused variable" warning and may cause other unintended effects.
> So here it is again.
> 

Oh wow...  I noticed this in the first patch and I couldn't figure
out why the blen = 0 was there...  It never occurred to me that it
was to silence the warning.  :P  That's hilarious.

The blen variable is only used in commented out code.  Don't do
this.  Please delete everything to do with blen.  It's there in the
history if anyone wants to see it.  Delete "bn" as well.

regards,
dan carpenter

