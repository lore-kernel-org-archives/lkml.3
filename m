Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaJPIKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:10:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35888 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaJPIKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:10:17 -0400
Date: Thu, 16 Oct 2014 11:09:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141016080957.GS26918@mwanda>
References: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015195549.GR26918@mwanda>
 <1413404767.2412.31.camel@jtkirshe-mobl>
 <20141016075211.GE23154@mwanda>
 <1413446382.2412.57.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413446382.2412.57.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

COMPILE_TEST is just so that you can view build warnings.  We would say:

depends on USB && NET && (!64BIT || COMPILE_TEST)

of

depends on USB && NET && (X86_32 || (X86 && COMPILE_TEST))

If you don't have USB or NET, you're get build errors but they don't
indicate bugs.  If you build on X86_64 the warnings are real bugs.

regards,
dan carpenter
