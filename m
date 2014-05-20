Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaETPHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:07:48 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62475 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbaETPHp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:07:45 -0400
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <julia.lawall@lip6.fr>
CC: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/13 v2] [SCSI] qla2xxx: make return of 0 explicit
Thread-Topic: [PATCH 2/13 v2] [SCSI] qla2xxx: make return of 0 explicit
Thread-Index: AQHPc56YejEU5j1TE0y1VAc+6onFnZtJBIIAgAACroCAAV2EgA==
Date: Tue, 20 May 2014 15:07:30 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D01284E79BF@AVMB1.qlogic.org>
References: <1400474832-22422-1-git-send-email-Julia.Lawall@lip6.fr>
 <F5D084D6342F9B479C34599BB0A03E4D01284E742E@AVMB1.qlogic.org>
 <20140519201202.GA15585@mwanda> <alpine.DEB.2.10.1405200735210.3003@hadrien>
 <20140519234623.GA17724@mwanda>
In-Reply-To: <20140519234623.GA17724@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.35.7.47]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5055ED6B374C224EA997EA14D9DF3913@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7443 signatures=670450
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1405200182
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

>On Tue, May 20, 2014 at 07:36:48AM +0800, Julia Lawall wrote:
>> 
>> 
>> On Mon, 19 May 2014, Dan Carpenter wrote:
>> 
>> > On Mon, May 19, 2014 at 04:07:52PM +0000, Saurav Kashyap wrote:
>> > > Hi Julia,
>> > >
>> > > Status is already set to 0 at the beginning of the function, I think
>> > > we should just "return status" here to be consistent with the rest
>>of
>> > > the function.
>> >
>> > "return 0;" is more clear than "return status;".
>> >
>> > Consistency is great so long as it makes the code easier to read.
>>Don't
>> > lose track of the real goal.
>> 
>> If status were an informative word, there might be a reason for it.  But
>> integer typed functions almost always return their status, so there is
>>no
>> real information.
>
>Just to be clear, I'm agreeing with you...  "return 0;" is better.
>
>regards,
>dan carpenter
>

