Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3BRLZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:25:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22055 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3BRLZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:25:35 -0500
Date: Mon, 18 Feb 2013 14:25:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, devel@driverdev.osuosl.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging/xgifb: Remove code without effect
Message-ID: <20130218112507.GF6802@mwanda>
References: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
 <1360957033-11876-3-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360957033-11876-3-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 08:37:11PM +0100, Peter Huewe wrote:
> The tempal variable is assigned and then immediately overwritten.
> -> remove everything without effect.
> 
> The inb is kept for possible side effects.
> 

This was dead code after we removed old mode <= 14 support in
34c13ee2b "staging: xgifb: drop code for legacy VGA modes".

I don't know if the inb() is still needed.  Aaro?

regards,
dan carpenter

