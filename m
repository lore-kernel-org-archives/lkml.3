Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727Ab3BOQLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:11:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25339 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3BOQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:11:20 -0500
Date: Fri, 15 Feb 2013 19:11:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Rupesh Gujare <rupesh.gujare@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: Clang Analyzer was Re: [PATCH 3/7 v2] staging/ozwpan: Fix NULL
 vs zero in ozeltbuf.c (sparse warning)
Message-ID: <20130215161102.GK6853@mwanda>
References: <20130215084517.GB6802@mwanda>
 <1360938148-19225-3-git-send-email-peterhuewe@gmx.de>
 <20130215145226.GI6853@mwanda>
 <201302151657.14726.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302151657.14726.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you using this version of clang?:

http://git.linuxfoundation.org/llvmlinux.git/

regards,
dan carpenter
