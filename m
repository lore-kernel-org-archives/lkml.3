Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaCGIQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:16:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41038 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaCGIQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:16:48 -0500
Date: Fri, 7 Mar 2014 11:16:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
 of pfns we can handle
Message-ID: <20140307081627.GC29018@mwanda>
References: <1394176508-1439-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394176508-1439-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 11:15:08PM -0800, K. Y. Srinivasan wrote:
> Increase the maximum number of pfns we can handle is a single vmbus packet.
                                                    ^^ in
> 

What are the user visible effects of this patch?

regards,
dan carpenter

