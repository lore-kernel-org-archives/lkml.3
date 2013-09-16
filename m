Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab3IPUr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:47:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34936 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3IPUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:47:23 -0400
Date: Mon, 16 Sep 2013 23:38:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: thomas@m3y3r.de, Jiri Kosina <jkosina@suse.cz>, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to memdup
Message-ID: <20130916203824.GP25896@mwanda>
References: <5237430B.5040009@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237430B.5040009@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 01:42:35PM -0400, Joseph Salisbury wrote:
> Reverting the patch changes the driver back to useing kzalloc() and
> memcpy() instead of  kmemdup.  Doing so has uncovered another bug, which
> causes an oops on memcpy()[1].  We are in the process of bisecting that
> one now and will provide the results.

The two bugs are the same it's that the code has shifted a little.  Mark
the commit as buggy and continue with the git bisect.

regards,
dan carpenter
