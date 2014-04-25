Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaDYWBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:01:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:62856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaDYWBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,929,1389772800"; 
   d="scan'208";a="424129277"
From: "Hohndel, Dirk" <dirk.hohndel@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: how to include already compiled object files to kernel
Thread-Topic: how to include already compiled object files to kernel
Thread-Index: Ac9gojb8jtX0K20pQFGL2vOl15VYggAalj8A
Date: Fri, 25 Apr 2014 22:01:17 +0000
Message-ID: <1398463280.37783.3.camel@rrmbp.gr8dns.org>
References: <D854C92F57B1B347B57E531E78D05EAD574BFA6D@BGSMSX104.gar.corp.intel.com>
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD574BFA6D@BGSMSX104.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.17.220]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D029BC40924F5C4EADCA7ED257729429@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3PM1eCO010794

On Fri, 2014-04-25 at 16:24 +0000, Pallala, Ramakrishna wrote:
> HI All,
> 
> I have received few kernel library .o (object files) from third party and I am planning to include in our kernel tree. As the library contains some proprietary algorithms  the sources are not shared.
> 
> How can I include this library .o files to my kernel and if this kernel is release to customers will there be any license issues? Third party says the sources are under GPL.
> 

Oh joy. Just what I wanted to read today...

Our apologies; this is not a question or issue that should have been
posted to LKML.  Legal questions (such as what is permitted by any
particular license) by Intel employees are supposed to be directed to
Intel's legal department and not to public mailing lists.  Intel also
has a technical and business review process for reviewing *all* Open
Source software activities, including all Linux kernel contributions,
and the very first response from that review process would have been to
direct questions about license interpretation and permissible licensing
models to Intel's Legal Department.
 
We'll be following up with the development of this not-yet-released
product to ensure that it is fully compliant with the GPL and other open
source licenses as well as community-accepted practices, that it follows
Intel's normal review processes, and that all the developers involved
are familiar with Intel's policies for working with open source.
 
For those who have responded to the original mail, both privately and
publicly: thank you for your diligence and suggestions; we have been
working internally for the last few hours (literally since WE saw it on
the mailing list). But it's good to see that the community is as
responsive to these issues as we are.

And now back to our regularly scheduled emergencies.

/D


-- 
Dirk Hohndel
Chief Linux and Open Source Technologist
Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
