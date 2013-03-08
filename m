Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3CHT64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:58:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32842 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3CHT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:58:55 -0500
Date: Fri, 8 Mar 2013 22:58:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Message-ID: <20130308195839.GL9189@mwanda>
References: <20130308120215.GB18712@longonot.mountain>
 <513A2678.5000803@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A2678.5000803@interlog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 12:57:12PM -0500, Douglas Gilbert wrote:
> On 13-03-08 07:02 AM, Dan Carpenter wrote:
> 
> For 32 bytes, why not use the stack?
> 

It's a good point.  I'll resend on Monday.

regards,
dan carpenter

