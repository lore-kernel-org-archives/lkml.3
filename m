Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3KJVHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 16:07:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3KJVHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 16:07:08 -0500
Date: Mon, 11 Nov 2013 00:06:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 1/7] staging: go7007: fix use of uninitialised pointer
Message-ID: <20131110210647.GA5302@mwanda>
References: <1384108677-23476-1-git-send-email-mpn@google.com>
 <20131110185210.GA9633@kroah.com>
 <87fvr480o9.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvr480o9.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 other uses before "go" gets initialized.

regards,
dan carpenter

