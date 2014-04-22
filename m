Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaDVKHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:07:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33717 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaDVKHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:07:16 -0400
Date: Tue, 22 Apr 2014 13:06:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jinqiang Zeng <jinqiangzeng@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Elena Ufimtseva <ufimtseva@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ced1401 coding style fixes
Message-ID: <20140422100657.GF26890@mwanda>
References: <1397969728-11159-1-git-send-email-jinqiangzeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397969728-11159-1-git-send-email-jinqiangzeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject is in the wrong format.  It should be:

[PATCH 1/3] Staging: ced1401: fix long lines
[PATCH 2/3] Staging: ced1401: add blank lines after declarations
[PATCH 3/3] Staging: ced1401: remove unused typedefs

Btw, break it up into 3 patches.

regards,
dan carpenter

