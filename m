Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaAQOvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:51:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37320 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAQOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:51:41 -0500
Date: Fri, 17 Jan 2014 17:51:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, devel@driverdev.osuosl.org,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Message-ID: <20140117145128.GR7444@mwanda>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117143329.GA6877@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will want to get rid of lustre's custom allocator before this gets
out of staging.

But one feature that the lustre allocator has which is pretty neat is
that it lets you debug how much memory the filesystem is using.  Is
there a standard way to find this information?

regards,
dan carpenter

