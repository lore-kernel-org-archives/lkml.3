Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaDCRxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:53:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDCRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:53:17 -0400
Date: Thu, 3 Apr 2014 20:52:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: armand.bastien@laposte.net
Cc: willy@meta-x.org, gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        jake.champlin.27@gmail.com, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging : panel : fix checkpatch warnings (linux-next)
Message-ID: <20140403175252.GN6991@mwanda>
References: <20140403165859.GA10253@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403165859.GA10253@plop.dartybox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 06:59:09PM +0200, armand.bastien@laposte.net wrote:
> This patch fixes "Missing a blank line after declarations" checkpatch warning in panel.c.
> 
> 
> Signed-off-by: "Bastien Armand <armand.bastien@laposte.net>"

Fix your email client to use the proper From header.  The signed-off-by
format is wrong as well (extra quotes).  The subject should be:

[PATCH] staging: panel: add blank lines after declarations

The original had extra space characters.  Don't put "(linux-next)" in
the permanent log.  Be as specific as you can in roughly 52 characters.

Otherwise it looks ok.

regards,
dan carpenter

