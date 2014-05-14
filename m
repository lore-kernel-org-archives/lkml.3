Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaENVzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:55:46 -0400
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:40580 "EHLO
	smtp1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753053AbaENVzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:55:44 -0400
Message-ID: <5373E658.2040701@sec.in.tum.de>
Date: Wed, 14 May 2014 23:55:36 +0200
From: Julian Kirsch <kirschju@sec.in.tum.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Christian Grothoff <christian@grothoff.org>
Subject: Collecting data to demonstrate TCP ISN-based port knocking
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi list,

some of you might remember the proposal of a patch which implements a
variant of port-knocking that can be used to check the authenticity of
arbitrary TCP connections and even can do integrity checking of TCP
payload data by using a pre-shared key [0]. This patch, as well as a
research paper describing its inner workings are available on
gnunet.org under the name "Knock" [1].

As Knock uses two fields in the TCP header in order to hide
information and we explicitly want to be compatible with machines
sitting in typical home networks, we need to make sure that this
information doesn't get corrupted by the majority of NAT boxes out
there. The lack of hard data on this also was one of the objections
when the patch was submitted last time. We thus created a program
which tests if Knock could work in your environment. It would be
greatly appreciated if some of you were able to execute the program on
their machines in order to help us to get an estimation of if Knock
one day could be used in a large scale.

You can find sources, binaries and a more elaborate description here:
https://gnunet.org/knock_nat_tester


Best,
Julian Kirsch

- ---
[0] https://lkml.org/lkml/2013/12/10/1155
[1] https://gnunet.org/knock
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTc+ZUAAoJENwkOWttRRA4iicH/RLvNrlI0SCkHp25RZ1e5/8B
aBO/voua2a0Xw+F1E+60VKAv0Mm9arS1kpySkNuH+GEc2iVau6TmM7wDdZ5V7DaZ
nGpEnx6cS5mVx01qvalWtTUq2XwoVYz9x5mvaZkIt41DjsFxO/EqAyXudwCILRpJ
QMidYhpinjzfq1MgWIyOCLGmFzbUthIEtk/og9dHr8bg1r1bS8CQaQ42js7baa2n
nujp529LMHx+eHZ/f0owkmx5ssoJtpHsgVQr/kTBmAuJwELlOiToMWMCa9uCBbuB
KKjLcrQogX1OjeFPwE7r0hjckn7rQbu1f5GUIGvPV0kYlfUtmknTJ1kHW4FXJxA=
=pW9x
-----END PGP SIGNATURE-----
