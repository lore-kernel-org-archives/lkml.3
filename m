Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaCFJZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:25:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaCFJZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:25:22 -0500
Date: Thu, 6 Mar 2014 12:24:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fred Akers <knivey@botops.net>
Cc: greg@kroah.com, abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Staging: comedi: range: remove unnecessary sanity
 check
Message-ID: <20140306092446.GF26722@mwanda>
References: <20140306062333.GA19862@kroah.com>
 <1394089039-12408-2-git-send-email-knivey@botops.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394089039-12408-2-git-send-email-knivey@botops.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:57:19AM -0500, Fred Akers wrote:
> This check is unnecessary because range_table will always be
> initialized to range_unknown by comedi_device_postconfig() for
> drivers that do not initialize range_table or range_table_list
> 
> Signed-off-by: Fred Akers <knivey@botops.net>

Just merge these two into one patch.

regards,
dan carpenter

