Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3LCLE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:04:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39996 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LCLE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:04:27 -0500
Date: Tue, 3 Dec 2013 14:04:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky <micky_ching@realsil.com.cn>
Cc: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2 3/3] mfd: rtsx: prevent 'used uninitialised' warnings
Message-ID: <20131203110406.GN28413@mwanda>
References: <cover.1386051860.git.micky_ching@realsil.com.cn>
 <932dcc03570ceb86316272d4eba7f4207d001def.1386051860.git.micky_ching@realsil.com.cn>
 <20131203104003.GJ11828@lee--X1>
 <529DB86D.3010002@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529DB86D.3010002@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by is intended to have a legal meaning that you didn't steal
someone's code.  You can't sign off for other people.

regards,
dan carpenter

