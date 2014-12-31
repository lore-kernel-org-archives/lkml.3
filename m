Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaLaM7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:59:53 -0500
Received: from usfwa1cip1.exelisinc.com ([151.190.252.21]:7496 "EHLO
	usfwa1cip1.exelisinc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaM7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:59:51 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2014 07:59:51 EST
X-IronPort-AV: E=Sophos;i="5.07,672,1413244800"; 
   d="scan'208";a="346877687"
From: "Pittigher, Raymond - Exelis" <Raymond.Pittigher@exelisinc.com>
To: Margaret M Sanders <msanders@swri.org>, Paul Moore <paul@paul-moore.com>,
        =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: WASP for Linux 7?
Thread-Topic: WASP for Linux 7?
Thread-Index: AdAjryo1q8S2IFoLSLus7jMJEFjx8gBSOznp
Date: Wed, 31 Dec 2014 12:49:59 +0000
Message-ID: <32C7A2F6C25D3144BCAB45821D6F6D443766BEBB@USFWA1E14-02.corp.exelisinc.com>
References: <2AAF61416E46C443A2E009DC0ECCF02C0D89CC@swri16exbe1.electro.swri.edu>
In-Reply-To: <2AAF61416E46C443A2E009DC0ECCF02C0D89CC@swri16exbe1.electro.swri.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.17.51]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: linux-audit-bounces@redhat.com [linux-audit-bounces@redhat.com] on behalf of Margaret M Sanders [msanders@swri.org]
Sent: Monday, December 29, 2014 4:35 PM
To: Paul Moore; Toralf Förster
Cc: linux-audit@redhat.com; linux Kernel
Subject: WASP for Linux 7?

Expertise:

Is there a WASP for Linux 7? What is the accepted and accredited security scanning app for Linux 7--is it SECSCN?

Thank you,

MS
SwRI
ISSO/ATA

-----Original Message-----
From: linux-audit-bounces@redhat.com [mailto:linux-audit-bounces@redhat.com] On Behalf Of Paul Moore
Sent: Monday, December 29, 2014 1:42 PM
To: Toralf Förster
Cc: linux-audit@redhat.com; linux Kernel
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)

On Monday, December 29, 2014 05:24:38 PM Toralf Förster wrote:
> On 12/29/2014 05:21 PM, Paul Moore wrote:
> > On Mon, Dec 29, 2014 at 11:07 AM, Toralf Förster wrote:
> >> A x86 KVM guest running at a 64 bit Gentoo hardened host system the
> >> following crashes appeared reproducible (screen shots attached.
> >>
> >> If I removed syslog-ng from the runlevel default, then the crash
> >> just appeared a little bit later at another subsystem>
> >
> > It looks like it doesn't like something in
> > audit_compare_dname_path(); I'll take a look and see what I can
> > find, there is a patch in -rc2 which touched some related code.
> >
> > I didn't see this problem in my earlier testing, can you share your
> > .config?
>
> ofc - attached

[NOTE: added linux-audit to the CC line, I should have done that earlier]

I believe I can reproduce this now; I'm seeing slightly different panics, but it is "close enough" and based on some quality time with the code I believe they are both symptoms of the same root cause.

To help verify that I'm heading down the right path, could you share your audit configuration as well?  If that's not possible, can you at least confirm that you using a few audit directory watches?

--
paul moore
www.paul-moore.com



Try Using OpenSCAP. I do not think that RHEL7 has been approved yet and I do not see the rules on NIPR or SIPR.

________________________________

This e-mail and any files transmitted with it may be proprietary and are intended solely for the use of the individual or entity to whom they are addressed. If you have received this e-mail in error please notify the sender. Please note that any views or opinions presented in this e-mail are solely those of the author and do not necessarily represent those of Exelis Inc. The recipient should check this e-mail and any attachments for the presence of viruses. Exelis Inc. accepts no liability for any damage caused by any virus transmitted by this e-mail.
