Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaDVJ2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:28:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaDVJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:28:12 -0400
Date: Tue, 22 Apr 2014 12:27:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Son P. Nguyen" <fastmutex@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Staging: dgnc: dgnc_driver: fixed dgnc_pci_tbl
 definition
Message-ID: <20140422092754.GA26890@mwanda>
References: <1397947691-19232-2-git-send-email-fastmutex@gmail.com>
 <1398017139-22231-1-git-send-email-fastmutex@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398017139-22231-1-git-send-email-fastmutex@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the idea of this patch but the v2 version still doesn't compile.
I don't understand how you can write such a nice patch and not even test
that it compiles.  Twice.  That's not ok.

On Sun, Apr 20, 2014 at 06:05:38PM +0000, Son P. Nguyen wrote:
> From: "Son P. Nguyen" <fastmutex@gmail.com>

Don't include this when you are sending your own patch.

> 
> Fixed dgnc_pci_tbl definition for correct coding style

This description is not enough.

> 
> PS: This is for task 10 of eudyptula-challenge.

Don't include this line.

regards,
dan carpenter

