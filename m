Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaEBIhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:37:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39358 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaEBIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:36:58 -0400
Date: Fri, 2 May 2014 11:36:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1.0 5/16] arcmsr: fix abort command function
Message-ID: <20140502083636.GC4963@mwanda>
References: <1398854962.6930.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398854962.6930.14.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 06:49:22PM +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Fix abort command and its relate function.

The changelog should really say something about what the user visible
effects are for this bug.

regards,
dan carpenter
 
