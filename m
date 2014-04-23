Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaDWJ0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:26:06 -0400
Received: from mail-yh0-f57.google.com ([209.85.213.57]:53150 "EHLO
	mail-yh0-f57.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaDWJ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:26:03 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2014 05:26:03 EDT
X-Google-Doc-Id: 50c6bb2b24432481
X-Google-Web-Client: true
Date: Wed, 23 Apr 2014 01:49:06 -0700 (PDT)
From: Carlo Vitucci <vitucci.carlo@gmail.com>
To: jailhouse-dev@googlegroups.com
Cc: Carlo Vitucci <vitucci.carlo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Sabony, Mazda" <Mazda.Sabony@amd.com>
Message-Id: <e08f8eed-2465-494e-a170-5246d3109c8b@googlegroups.com>
In-Reply-To: <53577D3C.5060103@siemens.com>
References: <534C2884.7050004@siemens.com> <b95ba76d-c3a9-458e-b9a9-10ca28886d55@googlegroups.com>
 <53577D3C.5060103@siemens.com>
Subject: Re: Developer wanted: AMD64 port of Jailhouse hypervisor
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_47_7521642.1398242946354"
X-Google-Token: EIL93ZoFe2vrrwlvouk0
X-Google-IP: 88.131.84.244
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_47_7521642.1398242946354
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Il giorno mercoled=C3=AC 23 aprile 2014 10:43:40 UTC+2, J. Kiszka ha scritt=
o:
> On 2014-04-23 08:21, Carlo Vitucci wrote:
>=20
> > Il giorno luned=C3=AC 14 aprile 2014 20:27:16 UTC+2, J. Kiszka ha scrit=
to:
>=20
> >> Hi all,
>=20
> >>
>=20
> >>
>=20
> >>
>=20
> >> so far the Linux-based Jailhouse hypervisor [1] is only available for
>=20
> >>
>=20
> >> Intel x86 CPUs. I'm now very happy to announce that AMD is offering to
>=20
> >>
>=20
> >> sponsor the initial port of Jailhouse to the AMD64 architecture. Our
>=20
> >>
>=20
> >> resources here are unfortunately bound to different tasks, but if anyo=
ne
>=20
> >>
>=20
> >> out there with the required skills is interested in working on this
>=20
> >>
>=20
> >> project, just reply to this email or contact me and Mazda directly.
>=20
> >>
>=20
> >>
>=20
> >>
>=20
> >> The work to be done is manageable: we basically need corresponding
>=20
> >>
>=20
> >> implementations of vmx.c and vtd.c in the current Jailhouse code base =
-
>=20
> >>
>=20
> >> provided our existing abstractions were done right. Someone familiar
>=20
> >>
>=20
> >> with virtualization on x86 in general and, ideally, even on AMD
>=20
> >>
>=20
> >> processors should be able to complete this task within a couple of wee=
ks.
>=20
> >>
>=20
> >>
>=20
> >>
>=20
> >> For more details on the Jailhouse architecture and implementations, se=
e
>=20
> >>
>=20
> >> our slowly growing Documentation folder in the source tree or simply a=
sk
>=20
> >>
>=20
> >> on the mailing list.
>=20
> >>
>=20
> >>
>=20
> >>
>=20
> >> Jan
>=20
> >>
>=20
> >>
>=20
> >>
>=20
> >> [1] https://github.com/siemens/jailhouse
>=20
> >>
>=20
> >>
>=20
> >>
>=20
> >> --=20
>=20
> >>
>=20
> >> Siemens AG, Corporate Technology, CT RTC ITP SES-DE
>=20
> >>
>=20
> >> Corporate Competence Center Embedded Linux
>=20
> >=20
>=20
> > Hello jailhouse,
>=20
> >  just a thought, if I could. AMD64 is not officially delivered and one
>=20
> >  of the most important new features, that is the direct interrupt deliv=
ery,
>=20
> >  is without a final specification. in other words, ARMv8 is the only su=
itable
>=20
> >  architecture for Jailhouse porting, but there is still a bit fog aroun=
d.
>=20
>=20
>=20
> I'm not sure if I got your point yet: AMD64 stands for the
>=20
> well-established x86-64 architecture with AMD-specific parts like the
>=20
> virtualization extensions. All these transistors and specs are broadly
>=20
> available for years.
>=20
>=20
>=20
> Regarding direct interrupt delivery: on Intel, we do not depend on
>=20
> specific hardware support to provide this feature, and I bet we can port
>=20
> that approach to AMD as well.
>=20
>=20
>=20
> Jan
>=20
>=20
>=20
> --=20
>=20
> Siemens AG, Corporate Technology, CT RTC ITP SES-DE
>=20
> Corporate Competence Center Embedded Linux

Sorry Jan,
 my misyake. I was referring to ARMv8 architecture, but I wrote AMD64 at th=
e beginning instead of ARM64... sorry for the confusion!
BR/
Carlo
------=_Part_47_7521642.1398242946354--
