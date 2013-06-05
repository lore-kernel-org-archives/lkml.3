Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3FEJtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:49:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44844 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3FEJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:49:22 -0400
Date: Wed, 5 Jun 2013 12:48:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: devel@driverdev.osuosl.org, Kurt Kanzenbach <shifty91@gmail.com>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 2/6] keucr: fix some camelCase warnings
Message-ID: <20130605094824.GT28112@mwanda>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370422206-14961-3-git-send-email-of82ecuq@cip.cs.fau.de>
 <20130605092311.GO28112@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605092311.GO28112@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, to test how a patch will look to the maintainer:

1) save the whole email as text including headers and everything.
2) cat raw_email.txt | git am
3) git log -p

regards,
dan carpenter

