Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaESUMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:12:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaESUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:12:23 -0400
Date: Mon, 19 May 2014 23:12:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/13 v2] [SCSI] qla2xxx: make return of 0 explicit
Message-ID: <20140519201202.GA15585@mwanda>
References: <1400474832-22422-1-git-send-email-Julia.Lawall@lip6.fr>
 <F5D084D6342F9B479C34599BB0A03E4D01284E742E@AVMB1.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D01284E742E@AVMB1.qlogic.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 04:07:52PM +0000, Saurav Kashyap wrote:
> Hi Julia,
> 
> Status is already set to 0 at the beginning of the function, I think
> we should just "return status" here to be consistent with the rest of
> the function.

"return 0;" is more clear than "return status;".

Consistency is great so long as it makes the code easier to read.  Don't
lose track of the real goal.

regards,
dan carpenter

