Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaKVVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:09:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaKVVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:09:57 -0500
Date: Sun, 23 Nov 2014 00:09:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] [IA64] Deletion of unnecessary checks before the
 function call "unw_remove_unwind_table"
Message-ID: <20141122191420.GC5393@mwanda>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546FC455.8090702@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546FC455.8090702@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is buggy.

regards,
dan carpenter

