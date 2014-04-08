Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaDHLUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:20:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42998 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbaDHLUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:20:02 -0400
Date: Tue, 8 Apr 2014 14:19:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>, Joe Perches <joe@perches.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?us-ascii?B?PT91cy1hc2NpaT9RPz0zRD0zRnV0Zi04PTNGQj0zRlZNTzhiR2x1SU1T?=
	 =?us-ascii?B?d2VtVnk9M0Y9M0Q/PQ==?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: vt6655: iwctl.c: fix a sparse warning
Message-ID: <20140408111929.GG4963@mwanda>
References: <20140408110927.GA17308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408110927.GA17308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 07:09:27PM +0800, Jimmy Li wrote:
> thanks for correcting my patch format.
> 
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>
> ---
> v1 fix a sparse warning.
> 	(iwctl.c:1846:35: expected restricted gfp_t [usertype] flags)
> v2 clear up two unnecessary variable, buf and blen.
> v3 fix patch format.
>  drivers/staging/vt6655/iwctl.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Please try applying your patch.  Save the email as raw text including
headers and everything.  `cat raw_email.txt | git am`.  Then review the
log with `git log`.  You'll see that the format is still messed up.  :(

The part which should be discarded is saved and the part which should be
saved is deleted.

regards,
dan carpenter

