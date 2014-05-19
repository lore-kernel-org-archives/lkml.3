Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaESJRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:17:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaESJRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:17:13 -0400
Date: Mon, 19 May 2014 12:16:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Matlack <matlackdavid@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        charrer@alacritech.com, linux-kernel@vger.kernel.org, liodot@gmail.com
Subject: Re: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
Message-ID: <20140519091650.GS15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is great, thanks, don't resend.  But I wish the subject said
"fix" instead of "rewrite".  I was expecting it to just be a cleanup.

It helps a lot if `git log --oneline` says which patches should be
backported.

regards,
dan carpenter

