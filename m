Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaIBJUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:20:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaIBJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:20:02 -0400
Date: Tue, 2 Sep 2014 12:19:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: An Ha <zero579911@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] Staging: rtl8821ae: hal_bt_coexist: fix commenting
 style
Message-ID: <20140902091939.GB6600@mwanda>
References: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409617776-30730-1-git-send-email-zero579911@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm...  Now you've broken it into *too* many separate patches.  Also the
subjects are the same.  Also the subjects are too vague.  Which coding
style issue is addressed?

It should be something like:
patch 1: comments
patch 2: add/remove spaces
patch 3: fix quoted text
patch 4: braces
patch 5: add a blank line

regards,
dan carpenter

