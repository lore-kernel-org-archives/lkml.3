Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaAUUQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:16:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49677 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaAUUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:16:03 -0500
Date: Tue, 21 Jan 2014 23:16:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Message-ID: <20140121201601.GZ7444@mwanda>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com>
 <20140117145128.GR7444@mwanda>
 <20140117151735.GB16623@kroah.com>
 <CF037522.8B804%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF037522.8B804%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg meant mempools not slab.  You should look at it.  It does what you
need for debugging and solves a couple other problems as well.

We have a leak checker in the kernel but most people disable it.  I
forget the config name.  There are a bunch of useful debug configs.

regards,
dan carpenter
