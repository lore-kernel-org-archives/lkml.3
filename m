Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaKRGnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:43:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaKRGnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:43:40 -0500
Date: Tue, 18 Nov 2014 09:43:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Juston <juston.h.li@gmail.com>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        oleg.drokin@intel.com, HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: mdc: use __FMODE_EXEC macro
Message-ID: <20141118064314.GJ4905@mwanda>
References: <1416263028-16026-1-git-send-email-juston.h.li@gmail.com>
 <20141117224616.GI4905@mwanda>
 <1416270188.18197.16.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416270188.18197.16.camel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 04:23:08PM -0800, Juston wrote:
> Seems to be the case. Looked at some old commits (2.6.17) and found
> FMODE_EXEC was mainlined to allow lustre to be installed on a vanilla
> kernel.

We actually only care about the most recent kernel.  I think you can
remove the ifdefs in this case.

regards,
dan carpenter

