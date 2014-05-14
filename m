Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaENOyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:54:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23869 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaENOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:54:06 -0400
Date: Wed, 14 May 2014 17:53:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jinqiang Zeng <jinqiangzeng@gmail.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dgap: fix sparse warnings
Message-ID: <20140514145349.GB8897@mwanda>
References: <1400078488-22391-1-git-send-email-jinqiangzeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400078488-22391-1-git-send-email-jinqiangzeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should be working against linux-next.  Also Mark Hounschell has sent
a fix for this already but it hasn't been applied yet.  The subject
should have "Staging" in it.

[PATCH] Staging: dgap: addd __iomem annotations.

Otherwise looks ok.

regards,
dan carpenter


