Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaGVJRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:17:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:41364 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbaGVJR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:17:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,709,1400050800"; 
   d="asc'?scan'208";a="565358264"
Date: Tue, 22 Jul 2014 04:46:41 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140722084641.GA5730@gchen.bj.intel.com>
References: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jul 22, 2014 at 04:04:52PM +0800, Wanpeng Li wrote:
> Subject: [PATCH v2] x86, hotplug: fix llc shared map unreleased during cpu
>  hotplug

See this link:
https://lkml.org/lkml/2014/7/17/78

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTziTxAAoJEI01n1+kOSLHJPkP/2bqIMSPT6Hpt2RwZredrFSs
k1mdZbXQ5o6tRI7mHdcQ5M9I6t7mH8fBD9kEp8i0ouI3iFkka2NAZ99Iwctl7ihZ
HbyAPzTm+83GSIY2Wq/iN/dFDvVRVZCvNH3xOqqiwYuJJUVcrfBydB9hFCsyjyPi
MRpV6pbdBp7OIOqhtMJhv+4f/b0KU5lGi+LMToRLGxJQAX0hWfUJY0GZh+rjeF1n
9VUSw9E/GFEAIz2f1D9snsnyPMp5yRYEVZQUVZMhtWMUHBfSavQs4KYIA4F3X6z9
eaYRXUhlyVide2zh3ikWEFemzgSKxqPNiqfGjb3UB/vpqOQ54OIgPw+JXNG0rykF
Bjs+IEM+trEOIjAqEuFy9ZjXL7Z5feP3iZ5PdJhNLKYgoRsnymkIpv0aYbPZa7+G
TnHUhps0yL+SZLXFDqrWRNNHRlJIvf0rBl8SJpSBiXbS9A4URf4818nvcY4VrCzV
qrIvwiNSpYJV0eNmhw20rlv0Cc4IzInXJJ2nHZLZihLxMk2+VnuRf2jAazFw5I1B
TBPDNWiTucmQNhfcVQttYJ1Kj5aBeJB8aGqi5BmDahemKniNilUFaBhuHdE/sT8o
0rLRFJA02nrvOCdNNXNUiPGFu0UsC9eNX+SNEMFdi2e0GJK+v60xUSeowQ/WAF2k
0q2kXf7PPgAQNb0sjYrd
=pfwP
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
