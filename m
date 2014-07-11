Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaGKTke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:40:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20347 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaGKTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:40:32 -0400
Date: Fri, 11 Jul 2014 22:40:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dcb314@hotmail.com
Subject: Re: [PATCH v3] drivers/staging/comedi/drivers/ni_atmio16d.c: remove
 pointless condition
Message-ID: <20140711194000.GE25880@mwanda>
References: <1405089127-21646-1-git-send-email-abbotti@mev.co.uk>
 <1405089510-23182-1-git-send-email-abbotti@mev.co.uk>
 <CANZNk83KxB-FQkbe8xxYFY_htAM+MOvS1HPTBuvW2-LoKbfaQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk83KxB-FQkbe8xxYFY_htAM+MOvS1HPTBuvW2-LoKbfaQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:54:01PM +0300, Andrey Utkin wrote:
> 2014-07-11 17:38 GMT+03:00 Ian Abbott <abbotti@mev.co.uk>:
> > Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> 
> I think it's incorrect that you have instantly placed my signoff
> statement on this new patch.

Ian gave you credit but also wrote in the changelog that he modified the
patch from what you sent.  That's pretty normal.

regards,
dan carpenter
