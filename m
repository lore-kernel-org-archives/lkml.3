Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaFAUh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 16:37:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27523 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFAUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:37:26 -0400
Date: Sun, 1 Jun 2014 23:37:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Teodora Baluta <teobaluta@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u: r8192U_core.c:  Cleaning up
 uninitialized variables
Message-ID: <20140601203703.GO17724@mwanda>
References: <1401629315-18843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401629315-18843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 03:28:35PM +0200, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 

I've looked at the code, but I don't see this variable actually used
anywhere.  What is the exact cppcheck warning message?

regards,
dan carpenter

