Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3LaQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:56:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39819 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3LaQ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:56:06 -0500
Date: Tue, 31 Dec 2013 19:55:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net
Subject: Re: [PATCH 1/7] vt6655: Remove unused macros in 80211hdr.h
Message-ID: <20131231165548.GV28413@mwanda>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
 <1388415157-17615-2-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388415157-17615-2-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 03:52:31PM +0100, Michael Gunselmann wrote:
> From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
> 
> The file 80211hdr.h contained 4 macros (in both little and big endain fashion)
> that were not used in the driver. Thus, this patch removes them.
> 

Better to leave them in.  They are useful as documentation.

regards,
dan carpenter

