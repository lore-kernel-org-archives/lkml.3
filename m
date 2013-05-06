Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3EFRg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:36:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3EFRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:36:27 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Smart <james.smart@emulex.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (lpfc)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
	<5187D6F1.9070103@infradead.org> <1367858965.1868.24.camel@dabdike>
Date: Mon, 06 May 2013 13:36:16 -0400
In-Reply-To: <1367858965.1868.24.camel@dabdike> (James Bottomley's message of
	"Mon, 06 May 2013 09:49:25 -0700")
Message-ID: <yq1ehdkggdr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> drivers/built-in.o: In function `lpfc_bg_crc': (.text+0x3cb3c9):
>> undefined reference to `crc_t10dif'

James> That's the usual minor config cockup, isn't it?  lpfc apparently
James> also needs the generic checksum, so the fix would seem to be
James> this.

Patch ok as a short term fix.

Longer term I'd like to provide a helper function that HBAs can call to
validate the data and PI scatterlists.

-- 
Martin K. Petersen	Oracle Linux Engineering
