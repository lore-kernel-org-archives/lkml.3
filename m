Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaCESxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:53:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaCESxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:53:53 -0500
Date: Wed, 5 Mar 2014 21:53:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com, alexey.zhuravlev@intel.com, josh@joshtriplett.org,
        dulshani.gunawardhana89@gmail.com, jinshan.xiong@intel.com,
        "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH 1/2] lustre/mdc_lib: fix possible null pointer dereference
Message-ID: <20140305185048.GC26722@mwanda>
References: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 02:04:35PM +0100, Maxin B. John wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
> 
> cppcheck reported possible null pointer dereference in mdc_lib.c
> 
> [lustre/lustre/mdc/mdc_lib.c:233]: (error) Possible null pointer dereference
> : op_data - otherwise it is redundant to check if op_data is null at line 226
> 

There is only one caller and "op_data" is not NULL.

regards,
dan carpenter

