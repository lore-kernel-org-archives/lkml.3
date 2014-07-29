Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaG2TbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:31:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaG2TbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:31:11 -0400
To: KY Srinivasan <kys@microsoft.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>,
        "sitsofe\@gmail.com" <sitsofe@gmail.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw\@canonical.com" <apw@canonical.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering\@suse.com" <ohering@suse.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang\@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq17g30dprc.fsf@sermon.lab.mkp.net>
	<cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq138dnexcn.fsf@sermon.lab.mkp.net>
	<43306901b1dc4e5dbe014a431e0935ea@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq11tt5cnmx.fsf@sermon.lab.mkp.net>
	<548c8b1bae75483aa47c9493b62dc04d@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<1406577767.19418.11.camel@jarvis>
	<a445e81eb25f46918e85f51c631f6094@BY2PR0301MB0711.namprd03.prod.outlook.com>
Date: Tue, 29 Jul 2014 15:30:15 -0400
In-Reply-To: <a445e81eb25f46918e85f51c631f6094@BY2PR0301MB0711.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Tue, 29 Jul 2014 17:41:04 +0000")
Message-ID: <yq1bns8arp4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:

KY> We will fix this bug in the next release of Windows; we are also
KY> looking at backporting the fix to prior versions of Windows.

Excellent. Thanks for looking into this!

-- 
Martin K. Petersen	Oracle Linux Engineering
