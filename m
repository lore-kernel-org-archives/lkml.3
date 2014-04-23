Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbaDWIBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:01:40 -0400
Received: from mail-ob0-f192.google.com ([209.85.214.192]:52401 "EHLO
	mail-ob0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaDWIBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:01:38 -0400
X-Greylist: delayed 5506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2014 04:01:38 EDT
X-Google-Doc-Id: a331b2750c282cc7
X-Google-Web-Client: true
Date: Tue, 22 Apr 2014 23:21:33 -0700 (PDT)
From: Carlo Vitucci <vitucci.carlo@gmail.com>
To: jailhouse-dev@googlegroups.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Sabony, Mazda" <Mazda.Sabony@amd.com>
Message-Id: <b95ba76d-c3a9-458e-b9a9-10ca28886d55@googlegroups.com>
In-Reply-To: <534C2884.7050004@siemens.com>
References: <534C2884.7050004@siemens.com>
Subject: Re: Developer wanted: AMD64 port of Jailhouse hypervisor
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_445_30314692.1398234093217"
X-Google-Token: EO233ZoF73-pWaP6yW40
X-Google-IP: 88.131.84.244
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_445_30314692.1398234093217
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Il giorno luned=C3=AC 14 aprile 2014 20:27:16 UTC+2, J. Kiszka ha scritto:
> Hi all,
>=20
>=20
>=20
> so far the Linux-based Jailhouse hypervisor [1] is only available for
>=20
> Intel x86 CPUs. I'm now very happy to announce that AMD is offering to
>=20
> sponsor the initial port of Jailhouse to the AMD64 architecture. Our
>=20
> resources here are unfortunately bound to different tasks, but if anyone
>=20
> out there with the required skills is interested in working on this
>=20
> project, just reply to this email or contact me and Mazda directly.
>=20
>=20
>=20
> The work to be done is manageable: we basically need corresponding
>=20
> implementations of vmx.c and vtd.c in the current Jailhouse code base -
>=20
> provided our existing abstractions were done right. Someone familiar
>=20
> with virtualization on x86 in general and, ideally, even on AMD
>=20
> processors should be able to complete this task within a couple of weeks.
>=20
>=20
>=20
> For more details on the Jailhouse architecture and implementations, see
>=20
> our slowly growing Documentation folder in the source tree or simply ask
>=20
> on the mailing list.
>=20
>=20
>=20
> Jan
>=20
>=20
>=20
> [1] https://github.com/siemens/jailhouse
>=20
>=20
>=20
> --=20
>=20
> Siemens AG, Corporate Technology, CT RTC ITP SES-DE
>=20
> Corporate Competence Center Embedded Linux

Hello jailhouse,
 just a thought, if I could. AMD64 is not officially delivered and one
 of the most important new features, that is the direct interrupt delivery,
 is without a final specification. in other words, ARMv8 is the only suitab=
le
 architecture for Jailhouse porting, but there is still a bit fog around.
Best Regards,
Carlo
------=_Part_445_30314692.1398234093217--
