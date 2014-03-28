Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaC1KrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:47:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21761 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaC1KrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:47:13 -0400
Date: Fri, 28 Mar 2014 13:47:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Neil Armstrong <superna9999@gmail.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Archana kumari <archanakumari959@gmail.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix coding style issue in xlr_net.c
Message-ID: <20140328104704.GC6991@mwanda>
References: <5335444F.1050208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5335444F.1050208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject should be:

[PATCH] Staging: netlogic: long lines in xlr_net.c

You were missing the subsystem prefix:  "Staging: netlogic:".

regards,
dan carpenter

