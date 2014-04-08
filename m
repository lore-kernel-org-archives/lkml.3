Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbaDHO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:26:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50105 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbaDHO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:26:45 -0400
Date: Tue, 8 Apr 2014 17:26:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>, Joe Perches <joe@perches.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?us-ascii?Q?=3D=3Fus-ascii=3FB=3FPT91cy1hc2NpaT9RPz0zRD0zRnV0Zi04PTNG?=
	 =?us-ascii?Q?Qj0zRlZNTzhiR2x1SU1T=3F=3D_=3D=3Fus-ascii=3FB=3Fd2VtVnk9M0Y9?=
	 =?us-ascii?B?TTBRL1BRPT0/PQ==?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] Staging: vt6655: iwctl.c: fix a sparse warning
Message-ID: <20140408142611.GC4912@mwanda>
References: <20140408110927.GA17308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408110927.GA17308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:35:02PM +0800, Jimmy Li wrote:
> fix a sparse warning and do some clean up.
> iwctl.c:1846:35: expected restricted gfp_t [usertype] flags
> 
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>
> ---

Looks good.

regards,
dan carpenter

