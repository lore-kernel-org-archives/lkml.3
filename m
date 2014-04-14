Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaDNREM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:04:12 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:25194
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752960AbaDNREK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:04:10 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: RE: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Topic: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Index: AQHPWAHNedkd2X2EdkGHQBwaY8oyvZsRVoCAgAAAQsA=
Date: Mon, 14 Apr 2014 17:03:55 +0000
Message-ID: <9f719d321b714727832a2cb16727bcfb@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1397497584-23717-1-git-send-email-kys@microsoft.com>
 <534C148B.30005@zytor.com>
In-Reply-To: <534C148B.30005@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::3]
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(51704005)(24454002)(479174003)(377454003)(13464003)(199002)(189002)(31966008)(80022001)(83322001)(561944002)(85852003)(76576001)(79102001)(87936001)(46102001)(19580405001)(92566001)(76176999)(74316001)(2656002)(77096999)(74502001)(86362001)(50986999)(54356999)(81542001)(80976001)(83072002)(33646001)(4396001)(99286001)(86612001)(20776003)(99396002)(19580395003)(76482001)(74662001)(77982001)(81342001)(1121002)(921003)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B6DEE102.9A33A41A.B0FBADBF.4CE0CA6B.20256;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Monday, April 14, 2014 10:02 AM
> To: KY Srinivasan; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com
> Subject: Re: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic
> appropriately
> 
> On 04/14/2014 10:46 AM, K. Y. Srinivasan wrote:
> > This patch implements the proposal put forth by H. Peter Anvin
> <hpa@linux.intel.com>.
> >
> > In  version V1 of the patch, I had cleaned up the code based on comments
> from Peter.
> > In  version V2 of the patch, I have addressed additional comments from
> Peter.
> > In this version of the patch, I have addressed Jan's comments
> (JBeulich@suse.com).
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Technically the patch looks good, but I'm going to have to reject it based on
> the patch description.
> 
> Keep in mind that the above description is the only thing that would go into
> the git repository, and needs to be understandable to someone, say,
> 10 years from now.
> 
> The above says nothing about what the proposal was, and the motivation,
> and the problems it addresses.  So the patch is good, but please write a
> proper, standalone description for it.

Thanks Peter; I will update the description and send it out soon.

K. Y
> 
> Thanks,
> 
> 	-hpa
> 

