Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3CPIdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 04:33:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3CPIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 04:33:17 -0400
Date: Sat, 16 Mar 2013 11:33:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 25/50] staging: omap-thermal: rewrite
 omap_bandgap_mcelsius_to_adc on kernel coding style
Message-ID: <20130316083307.GN9138@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <1363352438-15935-26-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352438-15935-26-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 09:00:13AM -0400, Eduardo Valentin wrote:
> Follow Documentation/CodingStyle while doing omap_bandgap_mcelsius_to_adc
> 

I have the same response for all these bunny hop patches.

When you're reading the code and you see a goto then you assume that
it's there for a reason so it's misleading when it doesn't do
anything.  It's simpler if the code is simple.

regards,
dan carpenter

