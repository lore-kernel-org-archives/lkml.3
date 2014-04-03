Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaDCRmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:42:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32213 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaDCRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:42:39 -0400
Date: Thu, 3 Apr 2014 20:42:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?us-ascii?Q?=3D=3Futf-8=3FB=3FVMO8bGluIMSwemVy=3F=3D?= 
	<tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers/staging/vt6655/iwctl.c fix a sparse warning
Message-ID: <20140403174208.GM6991@mwanda>
References: <20140403163229.GA21383@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403163229.GA21383@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:32:29AM +0800, Jimmy Li wrote:
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>

You dropped the commit message which said which sparse warnings were
fixed.  It should say something about the other cleanups as well. Also
the subject prefix isn't right.  Use:

[PATCH v3] Staging: vt6655: iwctl.c: fix a sparse warning

Or something.  "drivers/" doesn't add any information.

regards,
dan carpenter

