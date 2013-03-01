Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3CAQdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:33:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3CAQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:33:04 -0500
Message-ID: <5130D7F3.8070003@redhat.com>
Date: Fri, 01 Mar 2013 09:31:47 -0700
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 5/8] add a new qevent: QEVENT_GUEST_PANICKED
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <664d63ad19ae6ec25a5a7bd6411c8ab7e289f632.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <664d63ad19ae6ec25a5a7bd6411c8ab7e289f632.1362051582.git.hutao@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2LEJKNTXNLAPXXVSVIRFI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LEJKNTXNLAPXXVSVIRFI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/28/2013 05:13 AM, Hu Tao wrote:
> This event will be emited when the guest is panicked.
>=20
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  include/monitor/monitor.h | 1 +
>  monitor.c                 | 1 +
>  2 files changed, 2 insertions(+)

Missing documentation in QMP/qmp-events.txt

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2LEJKNTXNLAPXXVSVIRFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJRMNfzAAoJEKeha0olJ0NqgwkH/3PRDPzT8w77q0kbT1Vh9BpF
vY51ubc0lAY3VdqJSD7QrsrRXN7j5H17M+/pnclNrJMY/47HEbw5l2vFCSl9H3Zv
M2VW6gqMhTDqGv/F4WZPQf21TauhZ93VndEavl3YxKz+5sVpBZ1IwMFxhxRM5y1I
KvqnSp0p2FcrhyE1IJqVFCwxO/GldyRdil7M0mD4fclrLDmHdaYEoIZWhv556zXf
nY33l7FPLRRJWpJBwLhNwL6dA4zrtyyfAZIlBOtzvTvETSQ8BnGEJ/by0SjKKQuc
f4yXwXrPmQDD1BhmpvEgY/aYxauUQxahmJcATaUFLaaCCqoIzXDMJMkeff5gU7E=
=JEFt
-----END PGP SIGNATURE-----

------enig2LEJKNTXNLAPXXVSVIRFI--
