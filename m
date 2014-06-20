Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876AbaFTTxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:53:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30533 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbaFTTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:53:34 -0400
Date: Fri, 20 Jun 2014 22:53:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        lisa@xenapiadmin.com, ben@decadent.org.uk, valentina.manea.m@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192 Check for Null return from dev_skb_alloc
Message-ID: <20140620195334.GX5500@mwanda>
References: <1403282995-6688-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403282995-6688-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:49:55PM -0400, Nicholas Krause wrote:
> Checks for Null return from dev_skb_alloc if it returns Null,
> fw_download returns false. Otherwise it returns true.Also
> removed rt_status due to returning true of false directly.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---

What is this?  This patch is really bad and also doesn't apply.  Greg
already told you not to send any more patches until next week so it's
just going to be ignored...

Please slow down and don't send this again until it is correct.

regards,
dan carpenter

