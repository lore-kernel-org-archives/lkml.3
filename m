Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbbAGXqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:46:21 -0500
Received: from mailout.micron.com ([137.201.242.129]:50077 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbbAGXqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:46:18 -0500
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] block: pass correct seed to integrity metadata
 generation function
Thread-Topic: [PATCH] block: pass correct seed to integrity metadata
 generation function
Thread-Index: AdAbHdTOKR9VxT2kSG67KJv7w9th2QPtcy25AAAYpIA=
Date: Wed, 7 Jan 2015 23:46:13 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A994634DCA@NTXBOIMBX02.micron.com>
References: <54936D1E.3020700@micron.com> <54ADBC6E.50301@micron.com>
	<yq14ms25g21.fsf@sermon.lab.mkp.net>
	<80B89753B40C5141A3E2D53FE7A2A8A994634D2A@NTXBOIMBX02.micron.com>
 <yq1r3v640pg.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1r3v640pg.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21230.002
x-tm-as-result: No--32.176200-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, January 07, 2015 3:43 PM
> To: Sam Bradshaw (sbradshaw)
> Cc: Martin K. Petersen; axboe@kernel.dk; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] block: pass correct seed to integrity metadata
> generation function
> 
> >>>>> "Sam" == Sam Bradshaw (sbradshaw) <sbradshaw@micron.com> writes:
> 
> Sam> Yes, you were CC: on the original.  Could you take a peek at the
> Sam> patch and give me feedback?  https://lkml.org/lkml/2014/12/18/521
> 
> Is the target an NVMe device?

Yes.

