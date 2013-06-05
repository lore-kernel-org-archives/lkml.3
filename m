Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3FEJZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:25:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32987 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3FEJZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:25:54 -0400
Date: Wed, 5 Jun 2013 12:25:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 1/6] keucr: remove some unneccesary typedefs
Message-ID: <20130605092502.GP28112@mwanda>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370422206-14961-2-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370422206-14961-2-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:50:01AM +0200, Johannes Schilling wrote:
> resolves checkpatch.pl warning "do not add new typedefs"
> 

If you're going to do this, then you may as well give the struct a
better name at the same time.

regards,
dan carpenter

