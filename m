Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826AbaDMV0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:26:19 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54552 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbaDMV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:26:18 -0400
Message-ID: <1397424375.31896.7.camel@x220>
Subject: Re: [PATCH v2 1/3] Fix alignement problems in
 drivers/staging/crystalhd/crystalhd_lnx.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Pascal COMBES <pascom@orange.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Robert Foss <dev@robertfoss.se>
Date: Sun, 13 Apr 2014 23:26:15 +0200
In-Reply-To: <20140413210243.GK26890@mwanda>
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
	 <534AE0DE.6020404@orange.fr> <20140413210243.GK26890@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2014 21:26:16.0167 (UTC) FILETIME=[00A9C770:01CF575F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 00:02 +0300, Dan Carpenter wrote:
> The subeject should be:
> 
> [PATCH v2 1/3] Staging: crystalhd: Fix alignement in crystalhd_lnx.c
> 
> Please resend it.  Also you should use shorter subject lines.
> 
> "Fix coding style problem (cast with space) in drivers/staging/crystalhd/crystalhd_lnx.c"
> 
> This is too long.  Say:
> 
> "Remove a stray space character in crystalhd_lnx.c"

The commit explanation also was a copy of the subject line. That
suggests that the explanation can be dropped. Many trivial fixes can
(and should) be submitted without a commit explanation.


Paul Bolle

