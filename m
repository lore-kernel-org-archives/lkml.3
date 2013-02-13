Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab3BMO72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:59:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19324 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab3BMO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:59:27 -0500
Date: Wed, 13 Feb 2013 17:58:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ian Abbott <abbotti@mev.co.uk>, devel@driverdev.osuosl.org,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging/comedi: Fix undefined array subscript
Message-ID: <20130213145856.GB4606@mwanda>
References: <20130213140147.GA4606@mwanda>
 <1360765694-3748-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360765694-3748-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks great.  :)  Thanks for fixing this bug.

regards,
dan

