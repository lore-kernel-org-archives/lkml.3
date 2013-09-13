Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3IMTNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:13:48 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:9681
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755130Ab3IMTNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:13:46 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/13] hv: clean up dev_attr usage
Thread-Topic: [PATCH 00/13] hv: clean up dev_attr usage
Thread-Index: AQHOsK+1mcM+7wT8AkG+31wmWIBnRpnECUGA
Date: Fri, 13 Sep 2013 19:13:42 +0000
Message-ID: <a9de297afbbd4c67b40c52b0eb37c960@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.227]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0968D37274
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(13464003)(51704005)(199002)(189002)(1511001)(77096001)(81816001)(77982001)(80976001)(56816003)(81686001)(59766001)(76796001)(50986001)(76786001)(63696002)(76576001)(54356001)(74366001)(79102001)(65816001)(76482001)(74316001)(46102001)(83072001)(74502001)(51856001)(83322001)(19580405001)(19580395003)(47446002)(31966008)(74662001)(4396001)(54316002)(33646001)(56776001)(49866001)(47976001)(47736001)(74706001)(81342001)(81542001)(69226001)(66066001)(74876001)(80022001)(53806001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:131.107.174.227;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, September 13, 2013 11:33 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 00/13] hv: clean up dev_attr usage
> 
> Hi,
> 
> Here's a set of 13 patches to get rid of the dev_attrs use in the hv bus
> code, as it will be going away soon.  It's _way_ bigger than all other
> conversions I've had to do so far in the kernel, as you were using a
> "multiplexor" function for all of these files.
> 
> So, I've broken it up into individual show/store sysfs functions, and
> cleaned up a bunch of debug structures that aren't needed and shouldn't
> be exported to the rest of the kernel.
> 
> I've also fixed up some void * usage in the hv core, in patch 07, to
> make things simpler and not so "magic" when dealing with these pages.
> If you could review that one closely to ensure I didn't mess anything
> up, I would appreciate it.
> 
> Also, are all of these files really needed for sysfs?  They seem to be
> all debugging stuff, shouldn't they go into debugfs if you really
> need/use them anymore?
> 
> KY, could you test these out?  I don't have access to a hv system at the
> moment.  I'll wait for your ack before applying them to any of my trees.
> 
> thanks,

Will do. Thank you.

K. Y
> 
> greg k-h

