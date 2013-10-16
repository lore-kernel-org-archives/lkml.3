Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100Ab3JPThv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:37:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16846 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3JPTht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:37:49 -0400
Date: Wed, 16 Oct 2013 22:37:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dhanunjaya <dhanunjaya.matrix@gmail.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, peterhuewe@gmx.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: xgifb: fix space prohibited before
 semicolon.
Message-ID: <20131016193704.GD11731@mwanda>
References: <1381949494-19886-1-git-send-email-dhanunjaya.matrix@gmail.com>
 <1381949494-19886-2-git-send-email-dhanunjaya.matrix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381949494-19886-2-git-send-email-dhanunjaya.matrix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:21:34AM +0530, Dhanunjaya wrote:
> This is a patch to the vb_table.h file that fixes the
> space prohibited before semicolon warning found by the
> checkpatch.pl tool.
> 

Someone already fixed this one.

Btw, for people who aren't aware, linux-next has moved to
git://gitorious.org/thierryreding/linux-next.git until later this month.
Thierry Reding has taken over while Stephen is on vacation.

regards,
dan carpenter

