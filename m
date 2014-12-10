Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaLJKDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:03:24 -0500
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:31338
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752551AbaLJKDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:03:21 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Topic: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Index: AQHQFFi+/HqrMoxqVky8TLtsfjYP+ZyIlqUg
Date: Wed, 10 Dec 2014 10:02:51 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E9BBE2@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
	<877fy1ht1u.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E9B80F@SIXPRD3002MB028.064d.mgd.msft.net>
 <87ppbrhnz9.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ppbrhnz9.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:206.191.249.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(377454003)(189002)(164054003)(13464003)(81156004)(106466001)(107046002)(86146001)(2656002)(87936001)(66066001)(21056001)(84676001)(50986999)(97756001)(106116001)(54356999)(76176999)(16796002)(31966008)(97736003)(99396003)(47776003)(64706001)(105606002)(20776003)(19580395003)(19580405001)(6806004)(69596002)(33656002)(55846006)(93886004)(77156002)(62966003)(50466002)(68736005)(46406003)(86362001)(86612001)(102836002)(92566001)(23726002)(120916001)(4396001)(110136001)(230783001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1210;H:064-smtp-out.microsoft.com;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1210;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 206.191.249.100)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1243;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Wednesday, December 10, 2014 17:08 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
> 
> Dexuan Cui <decui@microsoft.com> writes:
> 
> > Thanks,
> > -- Dexuan
> >
> >> -----Original Message-----
> >> From: Dexuan Cui
> >> Sent: Wednesday, December 10, 2014 15:34 PM
> >> To: 'Vitaly Kuznetsov'
> >> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> >> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> >> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> >> Subject: RE: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection
> work
> >>
> >> > -----Original Message-----
> >> > From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> >> > Sent: Tuesday, December 9, 2014 21:06 PM
> >> > To: Dexuan Cui
> >> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-
> >> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> >> > jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> >> > Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection
> work
> >> >  ......
> >> > > +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host
> >> > team.
> >> > > +	 *
> >> > > +	 * In the case the host only injects 1 IPv6 address:
> >> > > +	 * new_val->dhcp_enabled is true, but we can't pass
> >> > BOOTPROTO=dhcp to
> >> > > +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
> >> > > +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
> >> > > +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init
> >> > program
> >> > > +	 * ignores any static IP addr information once there is
> >> > > +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
> >> > > +	 *
> >> > > +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
> >> > > +	 * Ubuntu because it's ignored by the Ubuntu version of
> >> > > +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
> >> > > +	 * Ubuntu.
> >> > > +	 */
> >> >
> >> > I just checked and adding "IPV6ADDR=something" when
> >> "BOOTPROTO=dhcp"
> >> > works for me with both RHEL7 and Fedora21.
> >> It doesn't work in my side. :-(
> >> Running 'ifup eth0' shows some errors(I use "set -x")
> >> ...
> >> + /sbin/dhclient -H localhost -1 -q -lf /var/lib/dhclient/dhclient--eth0.lease
> -pf
> >> /var/run/dhclient-eth0.pid eth0
> >> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> > BTW, I run with root, and
> > 'chown 777 /etc/sysconfig/network-scripts/ifcfg-eth0" doesn't help.
> >
> 
> s,chown,chmod, :-) But it won't help in case of SELinux mislabeling.
> 
> > Thanks,
> > -- Dexuan
> 
> --
>   Vitaly

Hi Vitally,
I think you're correct:
BOOTPROTO=dhcp + "no IPADDR" +  IPV6ADDR in RHEL7's 
/etc/sysconfig/network-scripts/ifcfg-eth0 works for me too.

My previous "grep: ... ifcfg-eth0: Permission denied" issue can't repro now.
Maybe it's because I messed up the config file somehow(?).

I'll send out a v2 patch according to your suggestion.

Thanks,
-- Dexuan 
