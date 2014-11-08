Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaKHVff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:35:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33570 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaKHVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:35:34 -0500
Date: Sun, 9 Nov 2014 00:35:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sharon <sharon.dvir1@mail.huji.ac.il>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH: Fix coding style warning.
Message-ID: <20141108213519.GD17639@mwanda>
References: <1415464746.12634.10.camel@mail.huji.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415464746.12634.10.camel@mail.huji.ac.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 06:39:06PM +0200, sharon wrote:
> Fix coding style warning.
> (First submission, sorry in advance for any dumb stuff I'm missing.
> Let me know and I'll fix it.)
> 

Everyone's first patch is rejected.
1) You need to work against linux-next.
2) Fix the subject:
   [PATCH] binder: lines too long
It has to be in that format.  `git am` will remove the [PATCH] part of
the subject.
3) Make the patch description as specific as possible.

regards,
dan carpenter
