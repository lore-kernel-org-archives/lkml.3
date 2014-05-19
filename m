Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaESVVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:21:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25278 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaESVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:21:20 -0400
Date: Tue, 20 May 2014 00:21:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Matlack <matlackdavid@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Lior Dotan <liodot@gmail.com>, linux-kernel@vger.kernel.org,
        charrer@alacritech.com
Subject: Re: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
Message-ID: <20140519212107.GC15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
 <20140519091650.GS15585@mwanda>
 <CANoiuGLzE=xbNjsFEsm9RAJrtEcGkd0rTy9t8ODzYEsGMUmNUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANoiuGLzE=xbNjsFEsm9RAJrtEcGkd0rTy9t8ODzYEsGMUmNUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you resend, please put in the changelog what the affect of this fix
is for the user.  Even if it's something like "It doesn't affect the
user normally." that is useful information.

regards,
dan carpenter

