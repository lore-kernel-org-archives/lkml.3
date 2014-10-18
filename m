Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaJRO1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:27:55 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:42339 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaJRO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:27:53 -0400
Date: Sat, 18 Oct 2014 10:27:31 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Gleb Natapov <gleb@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi.kivity@gmail.com>, stefano.stabellini@eu.citrix.com,
        Laszlo Ersek <lersek@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        konstantin@linuxfoundation.org
Message-ID: <432661354.65688167.1413642451475.JavaMail.zimbra@redhat.com>
Subject: new GPG key
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: new GPG key
Thread-Index: +YzTIiVknc9bmMhm0fHPt8Qutp4yIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

My backpack was stolen in Dusseldorf airport. I have started changing
passwords, and will also revoke my current GPG key soon. If you have
signed my previous key, or if you have an account on kernel.org, please
contact me so that I can have my new key signed soon.

Advice to people that use GPG routinely... If you are not doing it yet,
do the following, in increasing order of importance:

0) do not forget that you need a way to create a revocation certificate
(of course I had no problem with this). Paper, isolated machine (my
choice), USB key, whatever, but do it.

1) never put any 2-factor authentication tokens (which includes
phones!) in your backpack. Luckily I had my token and passport on
myself. Everything would have been **extremely** more complicated if
I hadn't. It also makes two factor authentication much more effective,
since a laptop after all is one of the easiest things to steal.

2) in addition to the usual encryption subkey, create one for signing
and use that instead of the master key; 3) put the master key on a USB
key, and replace it with a stub. These two steps are very easy to do and
enough to avoid having to rebuild the whole trust chain. Unfortunately,
it was on my todo list for, ehm, next week.

4) No, putting the master key and revocation certificate on the same
USB key is not a good idea.

5) Get a smartcard or a Yubikey NEO and put the subkeys on it; replace
subkeys with stubs on your usual working machines, especially laptops. It
gives you two factor authentication for free, and can also be used for
SSH if you add a third subkey.

This tutorial covers most of the above steps:
http://blog.josefsson.org/2014/06/23/offline-gnupg-master-key-and-subkeys-on-yubikey-neo-smartcard/

Thanks for your understanding,

Paolo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJUQnbQAAoJEBRUblpOawnXi60H/1gd7YEc9OHDwvPVPIAe7bUk
TfpITHNVD+wTVrelSW5i+w6Hv2i/EeKMhn26Z5RP5oWKHPQNJ5QCLS1i2JDraC7R
2KkOoBBKypHLYg1p2O7NxZB4Jh7ltYPHOQ3yqUDgEeofubF7Sj+kdo8c+eEFOJdl
ScALtdy99WoH7oWrXJIm7UmNQSvkKfF99Ur5PMuGGEP57RbgJGFYWihbgeyYRS9g
fFTCWC8Rka/BDsoFQJaFNQVhvWQLT14JJ6pRMNuCT4744wzX9ygRWZk34iwx4tNo
9Ys0QEvOR6ue7i/OvwDvUa5jL7uDJw/X0lg8qJiV/ZiSBuY3aIWBEPb5lnx0/uWJ
ARwEAQECAAYFAlRCdtAACgkQv/vSX3jHroOLrQf6A3SkeXlEt26F3E2AcmBbP9T1
ArIPMQ1uJXQWBai4hj0BpvzuUeIvvT6/jlQpkfspn09iD9TDYyNQz5n37NCVfzh2
yHKzDfXj6Hu5uQ13zbw8EvZj4cPQUHtKCT7wH+BPCmwd2Jd68MrscGyOz5emIGtZ
VHxM7c2FMR8C2LtOGJq/WbunqBSZLBECTXE8dyusW0ZDnnT72ZmSs7DDLqEk5Fy6
KJbLpfHLw9QTwDE9Ed/KauHZ+Sgdz50Lbv1MwWCT2Ep+2HS8nQJ71oXgAiB6vLSI
njB1bQfLGYS/k/sE/rlC1f+PEAquIbGXI6nSsiCFQdZnH6flkY/b8SWZe1uawg==
=SOwE
-----END PGP SIGNATURE-----
