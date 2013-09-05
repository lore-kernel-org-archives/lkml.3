Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3IEFqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:46:43 -0400
Received: from smtp2.stec-inc.com ([68.225.24.15]:42908 "EHLO
	smtp2.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3IEFql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:46:41 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2013 01:46:41 EDT
X-ASG-Debug-ID: 1378360189-401163f40001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
X-Barracuda-Apparent-Source-IP: fe80::30dd:fd5:3d97:5f13
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: RE: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
Thread-Topic: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
X-ASG-Orig-Subj: RE: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
Thread-Index: Ac6lfYb9h7EXiNWKSmiiNkzvW8LqcgABiNrIAR1IiTY=
Date: Thu, 5 Sep 2013 05:31:05 +0000
Message-ID: <26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad>,<x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: sacas02.stec-inc.ad[172.17.3.1]
X-Barracuda-Start-Time: 1378360189
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://saspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140355
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Thank you for reviewing the patch.

Regards,
Akhil
________________________________________
From: Jeff Moyer [jmoyer@redhat.com]
Sent: Friday, August 30, 2013 6:18 AM
To: OS Engineering
Cc: linux-kernel@vger.kernel.org; axboe@kernel.dk; Akhil Bhansali; Ramprasad Chinthekindi; Amit Phansalkar
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.

OS Engineering <osengineering@stec-inc.com> writes:

> Hello All,
>
> We are submitting device driver for sTec's PCIe flash card named "Kronos" for inclusion in linux kernel.
>
> Thanks.
> Akhil Bhansali.
> --
> From 3861f12cd99a9b1ba561296790ec482a75eeacd1 Mon Sep 17 00:00:00 2001
> From: Akhil Bhansali <abhansali@stec-inc.com>
> Date: Fri, 30 Aug 2013 11:32:49 +0530
> Subject: [PATCH] Patch for pcie device driver from sTec Inc.
>
> This patch adds "skd", a driver for sTec's PCIe flash cards named
> Kronos.
> Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
> Signed-off-by: Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>

This looks good to me.  It's nice to see another open source PCIe SSD
driver submitted!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
