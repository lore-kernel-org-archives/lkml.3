Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbbA2Bhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:37:50 -0500
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:57792
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756148AbbA2Bhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:37:47 -0500
Message-ID: <1422486205.10544.99.camel@freescale.com>
Subject: Re: [PATCH v2] powerpc/mpic: Add DT option to skip readback after
 EOI
From: Scott Wood <scottwood@freescale.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Bogdan Purcareata <bogdan.purcareata@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 28 Jan 2015 17:03:25 -0600
In-Reply-To: <20150128201533.GA10436@gate.crashing.org>
References: <1422371952-1126-1-git-send-email-bogdan.purcareata@freescale.com>
	 <1422395873.10544.61.camel@freescale.com>
	 <20150128201533.GA10436@gate.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: CO2PR11CA0008.namprd11.prod.outlook.com (10.141.242.146) To
 BN1PR0301MB0723.namprd03.prod.outlook.com (25.160.78.142)
Authentication-Results: kernel.crashing.org; dkim=none (message not signed)
 header.d=none;kernel.crashing.org; dmarc=none action=none
 header.from=freescale.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR0301MB0723;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0723;
X-Forefront-PRVS: 047001DADA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(24454002)(33646002)(42186005)(103116003)(50466002)(40100003)(122386002)(36756003)(47776003)(50226001)(23676002)(46102003)(87976001)(2950100001)(62966003)(110136001)(77156002)(92566002)(50986999)(76176999)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0723;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 23:03:33.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0723
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0707;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 14:15 -0600, Segher Boessenkool wrote:
> On Tue, Jan 27, 2015 at 03:57:53PM -0600, Scott Wood wrote:
> > At this point, given the previous discussion, does anyone object to
> > removing the readback entirely?  Do we have any evidence that reading
> > WHOAMI is effective at addressing whatever problem reading EOI made go
> > away on the relevant platform?
> 
> What platforms were those?  Just test there!

Ben said "some macs".  The only Mac I have is packed away and may not be
the one Ben had in mind, so I can't "test there".

> If no one remembers, they can not (any longer) be important platforms ;-)
> Just remove the code, and if in twelve months finally someone reports a
> failure we will at least know what platform it was.

This is what I was trying to encourage. :-)

-Scott


