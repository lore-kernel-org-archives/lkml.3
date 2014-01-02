Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaABPGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:06:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40995 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaABPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:06:15 -0500
Date: Thu, 2 Jan 2014 18:06:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: Trivial cleanups for drivers/hv/connection.c
Message-ID: <20140102150613.GB30234@mwanda>
References: <20131231215236.GA18573@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131231215236.GA18573@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 10:52:37PM +0100, Pavel Machek wrote:
> __u32 is only useful for kernel-user interface, u32 should be enough
> for kernel. Formatting was very confusing around __get_free_pages().
> 

The subject should say:
[PATCH] hv: Trivial cleanups for drivers/hv/connection.c

regards,
dan carpenter

