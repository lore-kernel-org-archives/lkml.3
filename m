Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaGaKWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:22:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35926 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaGaKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:22:37 -0400
Date: Thu, 31 Jul 2014 13:22:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fernando =?iso-8859-1?Q?Apestegu=EDa?= 
	<fernando.apesteguia@gmail.com>
Cc: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192u: Staticfy debug method.
Message-ID: <20140731102224.GN4856@mwanda>
References: <1406756021-3578-1-git-send-email-fernando.apesteguia@gmail.com>
 <20140731082051.GL4856@mwanda>
 <CAGwOe2aYVBbFjAAKtSojwSXF2p=d8AHgmWyHAofxmWQRht10ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGwOe2aYVBbFjAAKtSojwSXF2p=d8AHgmWyHAofxmWQRht10ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 11:10:33AM +0200, Fernando Apesteguía wrote:
> El 31/07/2014 10:21, "Dan Carpenter" <dan.carpenter@oracle.com> escribió:
> >
> > You need to compile these things before sending them...
> >
> > This adds a GCC warning about uncalled functions.
> 
> Sorry, but I did compile it with
> 
> make C=1 M=drivers/staging
> 
> But for the function to be called, DEBUG_EPROM must be defined and I
> had it defined. That's why I overlooked the warning.

Ah.  Ok.

regards,
dan carpenter

