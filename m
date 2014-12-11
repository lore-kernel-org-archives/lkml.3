Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbaLKACH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:02:07 -0500
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:35148
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758397AbaLKACF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:02:05 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Thread-Topic: [PATCH V2 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Thread-Index: AQHQFK4vlFEBm0maWECurtZG+5JIRZyJW/GAgAAl6LA=
Date: Thu, 11 Dec 2014 00:02:03 +0000
Message-ID: <BY2PR0301MB071185816BAE50CFB235315CA0630@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418243359-6887-1-git-send-email-kys@microsoft.com>
 <20141210214545.GA2699@hudson.localdomain>
In-Reply-To: <20141210214545.GA2699@hudson.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-forefront-prvs: 0422860ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(13464003)(199003)(189002)(24454002)(86612001)(77156002)(62966003)(107046002)(99396003)(122556002)(19580395003)(50986999)(46102003)(54356999)(19580405001)(40100003)(97736003)(120916001)(105586002)(76576001)(106116001)(106356001)(99286002)(64706001)(20776003)(33656002)(54606007)(86362001)(92566001)(21056001)(110136001)(87936001)(1411001)(2656002)(68736005)(101416001)(76176999)(54206007)(4396001)(31966008)(74316001)(102836002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: Wednesday, December 10, 2014 1:46 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V2 1/1] Drivers: hv: vmbus: Fix a bug in
> vmbus_establish_gpadl()
> 
> K. Y. Srinivasan,
> 
> On Wed, Dec 10, 2014 at 12:29:19PM -0800, K. Y. Srinivasan wrote:
> > Fix a bug in vmbus_establish_gpadl(). I would like to thank Michael
> > Brown <mcb30@ipxe.org> for seeing this bug.
> > In this version, I have added the Reported-by tag.
> 
> The log message should be more specific.  "Fix a bug" is too vague.
> Why is this patch necessary? What bug does it fix?  What changes did you
> make?
> 
> Saying you have "added the Reported-by tag" is not helpful in a log message.
> Although you can add notes for the patch reviewer under '---'.

Thank you; I will fix up the log and resend.

K. Y
