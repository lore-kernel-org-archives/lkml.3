Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3HPHNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:13:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3HPHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:13:54 -0400
Date: Fri, 16 Aug 2013 10:13:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Frederich <jfrederich@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        jon.nettleton@gmail.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Staging: olpc_dcon: replace some magic numbers
Message-ID: <20130816071338.GC26086@mwanda>
References: <1376595295-7820-1-git-send-email-jfrederich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376595295-7820-1-git-send-email-jfrederich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 09:34:55PM +0200, Jens Frederich wrote:
> The 0x42 initialize squence 0x101 is wrong.  According to
> the specification Bit 8 is reserved, thus not in use.
> I removed it.

Really these code changes should be in a separate patch and labeled
"Don't set reserved bit." instead of hidden away inside a cleanup
patch.

regards,
dan carpenter

