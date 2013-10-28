Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3J1OXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:23:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49229 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3J1OXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:23:08 -0400
MIME-Version: 1.0
Message-ID: <72e26ba4-7b4f-4b64-b58c-0042cbe89202@default>
Date: Mon, 28 Oct 2013 07:22:55 -0700 (PDT)
From: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
To: David Miller <davem@davemloft.net>, ben@decadent.org.uk
Cc: linux-kernel@vger.kernel.org, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org
Subject: RE: [PATCH 7/8] rds: Pass pointers to virt_to_page(), not integers
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
 <1382910856.2994.51.camel@deadeye.wl.decadent.org.uk>
 <20131028.002654.404759341390215962.davem@davemloft.net>
In-Reply-To: <20131028.002654.404759341390215962.davem@davemloft.net>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.8  (707110) [OL
 12.0.6680.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Sunday, October 27, 2013 11:27 PM
To: ben@decadent.org.uk
Cc: Venkat Venkatsubra; linux-kernel@vger.kernel.org; rds-devel@oss.oracle.com; netdev@vger.kernel.org
Subject: Re: [PATCH 7/8] rds: Pass pointers to virt_to_page(), not integers

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 27 Oct 2013 21:54:16 +0000

> Most architectures define virt_to_page() as a macro that casts its 
> argument such that an argument of type unsigned long will be accepted 
> without complaint.  However, the proper type is void *, and passing 
> unsigned long results in a warning on MIPS.
> 
> Compile-tested only.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

This looks fine:

Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
