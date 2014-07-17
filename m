Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaGQLwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:52:19 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:26816
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932258AbaGQLwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:52:15 -0400
X-WSS-ID: 0N8UUAV-07-69T-02
X-M-MSG: 
Message-ID: <53C7B8DC.2020705@amd.com>
Date: Thu, 17 Jul 2014 14:51:56 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "Sandeep Nair" <sandeep_n@ti.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        "Lucas Stach" <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's
 GPUs
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
	 <20140711170411.GJ1870@gmail.com> <1405099712.2796.19.camel@joe-AO725>
In-Reply-To: <1405099712.2796.19.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(377424004)(51704005)(189002)(24454002)(479174003)(79102001)(87936001)(77982001)(95666004)(4396001)(59896001)(101416001)(44976005)(86362001)(21056001)(65806001)(106466001)(105586002)(81342001)(64706001)(20776003)(47776003)(54356999)(76176999)(87266999)(65816999)(92726001)(99396002)(50986999)(31966008)(92566001)(83072002)(50466002)(85852003)(97736001)(83322001)(107046002)(68736004)(36756003)(81542001)(33656002)(74502001)(93886003)(23756003)(74662001)(46102001)(80022001)(65956001)(102836001)(83506001)(85306003)(84676001)(76482001)(64126003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 20:28, Joe Perches wrote:
> On Fri, 2014-07-11 at 13:04 -0400, Jerome Glisse wrote:
>> On Fri, Jul 11, 2014 at 12:50:09AM +0300, Oded Gabbay wrote:
> []
>>> +static long kfd_ioctl(struct file *, unsigned int, unsigned long);
>>
>> Nitpick, avoid unsigned int just use unsigned.
>
> I suggest unsigned int is much more common (and better)
> than just unsigned.
>
> $ git grep -P '\bunsigned\s+(?!long|int|short|char)' -- "*.[ch]" | wc -l
> 20778
>
> $ git grep -P "\bunsigned\s+int\b" -- "*.[ch]" | wc -l
> 98068
>
So I left it as unsigned int in v2 of the patchset.

>>> +static int kfd_open(struct inode *, struct file *);
>
> It's also generally better to use types and names tno
> improve how a human reads and understands the code.
>
>
Fixed in v2 of the patchset.

	Oded

