Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3IEQcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:32:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40561 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3IEQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:32:23 -0400
Date: Thu, 5 Sep 2013 19:32:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Avi <avi.kp.137@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: drivers/staging/bcm/InterfaceMisc.c-checkpatch
 cleanup-(foo*)->(foo *)
Message-ID: <20130905163216.GO6329@mwanda>
References: <20130905155154.GA7535@avi-VPCCW15FG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905155154.GA7535@avi-VPCCW15FG>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send this instead of as an attachment.  Send it to yourself first
and apply it with 'git am'.  Resend when that works.

> From: AVI <avi@avi-VPCCW15FG.(none)>
                 ^^^^^^^^^^^^^^^^^^^^
That's wrong.

The subject is too long and not the right format.  It should be:

Subject: [PATCH] Staging: bcm: white space complaint with casting

Put the exact complaint in the body of the email.

Add a blank line before the Signed-off-by line.

regards,
dan carpenter




