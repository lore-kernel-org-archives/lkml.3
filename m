Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaL2WWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 17:22:23 -0500
Received: from mail.swri.org ([129.162.252.40]:39331 "EHLO
	esg260-1.itc.swri.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaL2WWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 17:22:22 -0500
X-Greylist: delayed 2809 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2014 17:22:22 EST
From: Margaret M Sanders <msanders@swri.org>
To: Paul Moore <paul@paul-moore.com>,
        =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        linux Kernel <linux-kernel@vger.kernel.org>
Subject: WASP for Linux 7?
Thread-Topic: WASP for Linux 7?
Thread-Index: AdAjryo1q8S2IFoLSLus7jMJEFjx8g==
Date: Mon, 29 Dec 2014 21:35:23 +0000
Message-ID: <2AAF61416E46C443A2E009DC0ECCF02C0D89CC@swri16exbe1.electro.swri.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.162.162.66]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-29_03:2014-12-29,2014-12-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=inbound_policy_notspam policy=inbound_policy score=0
 kscore.is_bulkscore=2.77555756156289e-16 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.624711071532594
 urlsuspect_oldscore=0.998844286130374 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=0 rbsscore=0.624711071532594
 spamscore=0 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9
 adultscore=0 classifier=spam adjust=-40 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1412290217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


--
Linux-audit mailing list
Linux-audit@redhat.com
https://www.redhat.com/mailman/listinfo/linux-audit
