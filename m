Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaAGMes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:34:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51023 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaAGMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:34:40 -0500
Date: Tue, 7 Jan 2014 15:34:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net
Subject: Re: [PATCHv2 1/7] vt6655: balance faulty parentheses in 80211hdr.h
Message-ID: <20140107123439.GP30234@mwanda>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
 <1389096711-8595-2-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389096711-8595-2-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:11:45PM +0100, Michael Gunselmann wrote:
> From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
> 
> The file 80211hdr.h contained the macro WLAN_GET_FC_PRVER(n). The big endian
> fashion of this macro had unbalanced parentheses. This patch removes the
> parentheses in question.
> 

Good fix.  Next time, mention that this fixes a compile error and put
the GCC changelog if you have it.

(Don't redo the patch, it's fine as-is).

regards,
dan carpenter

