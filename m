Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaCGL1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:27:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21411 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCGL1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:27:05 -0500
Date: Fri, 7 Mar 2014 14:26:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
Message-ID: <20140307112655.GJ4774@mwanda>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:56:04AM +0100, Vegard Nossum wrote:
> Both the in-kernel and BSD strlcpy() require that the source string is
> NUL terminated.

No.  You're obviously wrong.  What on earth?

regards,
dan carpenter

