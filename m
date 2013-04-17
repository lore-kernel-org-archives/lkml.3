Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965721Ab3DQDas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 23:30:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965678Ab3DQDar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 23:30:47 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=ofFxtc/jepklO3aWSWiKGA==:17 a=99CFIlhQ8dUA:10 a=XqBCkJwx3yUA:10 a=bIxKA6TX_asA:10 a=vQlp3vXYDpMA:10 a=8nJEP1OIZ-IA:10 a=2KX_Yc5PAAAA:8 a=fkMt6HFWGF8A:10 a=6ohNodAXAAAA:8 a=bf6-jx-6U4rkcpHJ-RsA:9 a=wPNLvfGTeEIA:10 a=gDjHQkheYgsA:10 a=ofFxtc/jepklO3aWSWiKGA==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.112.99.80
Message-ID: <516E1763.7040206@tabi.org>
Date: Tue, 16 Apr 2013 22:30:43 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: Tang Yuantian-B29983 <B29983@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v2] of/base: release the node correctly in of_parse_phandle_with_args()
References: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com> <CAOZdJXW8qKccGKic3R4o1aqJdbfHcBoAp62B4HPFnF=sUAEvuQ@mail.gmail.com> <D07C73A334FF604B95B3CBD2A545D07B0B1456B8@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <D07C73A334FF604B95B3CBD2A545D07B0B1456B8@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang Yuantian-B29983 wrote:
>> >On Tue, Apr 9, 2013 at 10:36 PM,<Yuantian.Tang@freescale.com>  wrote:
>>> > >
>>> > >+                       /* Found it! return success */
>> >
>> >I'm pretty sure this comment is in the wrong place.

> It is not perfect, but acceptable.

Like I said, I'm pretty sure it's in the wrong place.

-- 
Timur Tabi
