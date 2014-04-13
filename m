Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaDMVDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:03:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41629 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaDMVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:03:14 -0400
Date: Mon, 14 Apr 2014 00:02:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pascal COMBES <pascom@orange.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Robert Foss <dev@robertfoss.se>
Subject: Re: [PATCH v2 1/3] Fix alignement problems in
 drivers/staging/crystalhd/crystalhd_lnx.c
Message-ID: <20140413210243.GK26890@mwanda>
References: <534AAED2.7050205@orange.fr>
 <20140413154859.GA18189@kroah.com>
 <534AE0DE.6020404@orange.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534AE0DE.6020404@orange.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subeject should be:

[PATCH v2 1/3] Staging: crystalhd: Fix alignement in crystalhd_lnx.c

Please resend it.  Also you should use shorter subject lines.

"Fix coding style problem (cast with space) in drivers/staging/crystalhd/crystalhd_lnx.c"

This is too long.  Say:

"Remove a stray space character in crystalhd_lnx.c"

On Sun, Apr 13, 2014 at 09:09:18PM +0200, Pascal COMBES wrote:
> From: Pascal COMBES <pascom@orange.fr>

Don't include this for your own patches, only when you are sending
someone else's.  We get the From information from the email header.

(This is harmless but it's bad style).

regards,
dan carpenter
