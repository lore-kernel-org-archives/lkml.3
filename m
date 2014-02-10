Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaBJJEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:04:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30011 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaBJJEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:04:02 -0500
Date: Mon, 10 Feb 2014 12:03:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hyperv: Fix the carrier status setting
Message-ID: <20140210090359.GQ26722@mwanda>
References: <1391994478-25809-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391994478-25809-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 05:07:58PM -0800, Haiyang Zhang wrote:
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Changelog sucks.  What are the user visible effects of this bug?

regards,
dan carpenter

