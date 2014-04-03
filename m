Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162420AbaDCJFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:05:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31161 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaDCJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:05:17 -0400
Date: Thu, 3 Apr 2014 12:04:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/vt6655/iwctl.c fix a sparse warning
Message-ID: <20140403090451.GE6991@mwanda>
References: <20140326074243.GA15228@gmail.com>
 <20140328032844.GC2263@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140328032844.GC2263@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 08:28:44PM -0700, Jimmy Li wrote:
> You are right, I found that variable buf also don't make sense here,
> maybe this could be more clear.
> 
>     param = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
>     if (param == NULL)
>         return -ENOMEM;
> 
> removing two unnecessary variable, buf and blen.
> 
> In this situation, I should send a new patch v2 for it base on the
> previous path? or send a new patch include all changes?

We throw away the original patch and you send a v2.  Use the subject:

[PATCH v2] drivers/staging/vt6655/iwctl.c fix a sparse warning

Under the Signed-off-by line put:
Signed-off-by: you
---
v2: additional cleanups as well.

regards,
dan carpenter

