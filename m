Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaAFIFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:05:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18265 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaAFIFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:05:52 -0500
Date: Mon, 6 Jan 2014 11:05:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com,
        linux-kernel@i4.cs.fau.de, andrea.merello@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        matthias.schoepe@studium.uni-erlangen.de, dhowells@redhat.com,
        valentina.manea.m@gmail.com, viro@zeniv.linux.org.uk,
        linville@tuxdriver.com
Subject: Re: [PATCH 2/3] Staging rtl8192e: Fixing checkpatch error in
 rtllib_debug.h
Message-ID: <20140106080520.GK30234@mwanda>
References: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
 <1388924737-1412-3-git-send-email-andreas.frembs@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388924737-1412-3-git-send-email-andreas.frembs@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 01:25:36PM +0100, Andreas Frembs wrote:
> In rtllib_debug.h we fixed the following checkpatch error:
> 	ERROR: Macros with complex values should be enclosed in parenthesis
> 
> We fixed this with a do {} while (0), because otherwise the compiler complained.
> 
> Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
> Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>

It would be better to replace these with WARN_ON().  I haven't looked
but I also suspect that some of these asserts might be bogus and should
be removed.

regards,
dan carpenter

