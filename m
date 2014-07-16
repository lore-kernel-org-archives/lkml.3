Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbaGPNRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:17:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18836 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbaGPNRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:17:50 -0400
Date: Wed, 16 Jul 2014 16:17:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Hounschell <markh@compro.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>, devel@driverdev.osuosl.org,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8 RESEND] staging: dgap: introduce dgap_cleanup_nodes()
Message-ID: <20140716130043.GC25880@mwanda>
References: <20140715091425.GA19095@devel.8.8.4.4>
 <790027403.325559.1405438239093.JavaMail.root@mx2.compro.net>
 <53C67285.4010008@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C67285.4010008@compro.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:39:33AM -0400, Mark Hounschell wrote:
> We also have this "DIGI_EXPANDERS_SUPPORTED" thingy. I have none of
> these cards. These cards interrogate the expander to find out how
> many ports there are. Then configure accordingly. Should we just
> remove all that code and NOT support expanders since we don't
> currently have the hardware to test?

Maybe eventually, but it's not like we have run out of other less
painfull cleanups that we can do right away.

regards,
dan carpenter

