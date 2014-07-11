Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaGKNcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:32:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28573 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGKNcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:32:08 -0400
Date: Fri, 11 Jul 2014 16:31:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Davide Gianforte <davide@gengisdave.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: silicom: function return fixes
Message-ID: <20140711133146.GB25880@mwanda>
References: <1972083.WZLDx2N35Z@mayhem>
 <1488578.ritUTSl26I@mayhem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488578.ritUTSl26I@mayhem>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these functions aren't called and can just be deleted.

regards,
dan carpenter

