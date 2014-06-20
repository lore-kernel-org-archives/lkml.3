Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaFTT7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:59:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20363 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaFTT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:59:32 -0400
Date: Fri, 20 Jun 2014 22:59:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, pebolle@tiscali.nl,
        himangi774@gmail.com, bergo.torino@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in
 halbcoutsrc
Message-ID: <20140620195926.GY5500@mwanda>
References: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:56:50PM -0400, Nicholas Krause wrote:
> Rewrites the wireless check for legacy checking in function
> halbtc_legacy to check for both Mode A and B.

You're just guessing that A and B were intended but it could have been
something B and G...

Don't do this.  Just leave the static checker warning there so someone
can fix it properly instead of introducing a second new bug and hiding
the warning so it's impossible to find.

regards,
dan carpenter

