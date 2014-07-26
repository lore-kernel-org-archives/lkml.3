Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaGZQzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:55:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48630 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaGZQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:55:31 -0400
To: KY Srinivasan <kys@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering\@suse.com" <ohering@suse.com>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        "jbottomley\@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
Date: Sat, 26 Jul 2014 12:54:47 -0400
In-Reply-To: <e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Sat, 26 Jul 2014 13:44:08 +0000")
Message-ID: <yq17g30dprc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:

>> The LBP VPD page flags UNMAP as being supported. Do you actually
>> support UNMAP to DSM TRIM SCSI-ATA translation?

KY> I have been told by the Windows folks that this is done. I am trying
KY> to get additional details.

Great! I'd just like to have a reasonable level of confidence in what's
happening down the stack before I entertain turning something on that's
not being properly advertised.

-- 
Martin K. Petersen	Oracle Linux Engineering
