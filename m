Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3JWXV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 19:21:57 -0400
Received: from carrot.rf.net.nz ([103.11.126.193]:51175 "EHLO carrot.rf.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab3JWXV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 19:21:56 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2013 19:21:55 EDT
From: Jasper Bryant-Greene <jbg@rf.net.nz>
Content-Type: multipart/signed; boundary="Apple-Mail=_3D636B03-16CD-4600-B789-DBC421C498E0"; protocol="application/pkcs7-signature"; micalg=sha1
Subject: EFI boot problem in 3.11
Message-Id: <32EA1272-FF5B-4FAA-B136-1447BF6F9876@rf.net.nz>
Date: Thu, 24 Oct 2013 12:14:26 +1300
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1812\))
X-Mailer: Apple Mail (2.1812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_3D636B03-16CD-4600-B789-DBC421C498E0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

I have a box here which is set up for EFI boot with no boot loader.

The kernel is compiled with a built-in initrd and command line.

In 3.10 this was all working well. However, after updating to 3.11.5 a =
reboot leads to the EFI firmware boot screen appearing followed by the =
middle section of it going black (just leaving two vertical stripes of =
the EFI firmware boot screen on either side of the screen) and the =
system locking up (numlock etc do not work).

However, if I hit =91delete=92 quickly when powering on, and enter the =
firmware setup screen, I can then =91exit without saving=92 and the =
system will boot successfully =97 =91save and exit=92 does not work as =
that performs a full reboot while =91exit without saving=92 seems to =
continue the boot where it left off.

Due to the aforementioned graphics corruption, I am wondering whether it =
is somehow related to the frame buffer? As this is a production system I =
unfortunately do not have flexibility to try a number of kernel versions =
in-between to locate where the issue was introduced.

All enabled .config options in the graphics section are: FB, FB_EFI, =
VGA_ARB, LOGO, LOGO_LINUX_CLUT224, VGA_CONSOLE, FRAMEBUFFER_CONSOLE

Please Cc me in replies.

Best,
Jasper Bryant-Greene


--Apple-Mail=_3D636B03-16CD-4600-B789-DBC421C498E0
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

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
rAAAAAAAAA==

--Apple-Mail=_3D636B03-16CD-4600-B789-DBC421C498E0--
