Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaAYJsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 04:48:19 -0500
Received: from mout.gmx.net ([212.227.17.22]:58112 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaAYJsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 04:48:17 -0500
Message-ID: <52E3885D.9030500@gmx.de>
Date: Sat, 25 Jan 2014 10:48:13 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de> <52E165B7.6020506@intel.com> <52E16E83.6060301@intel.com> <52E17273.2030200@gmx.de> <52E25E5D.1020806@redhat.com>
In-Reply-To: <52E25E5D.1020806@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:89lS6KpBRg/02AOHPHvVjueeW1hItOTPFwD95aMtuADzGtluNMX
 9WLo+xPEi8dHkiDRz1OXGfwbY5rjUnIvjNv4CgAwrp3H+VuMTxt1Wgrf3eJlkfgUnQOwEG/
 ZbH6jEKbAk2raJ5GF+I1AfDGWALkjsPSqmAABom2R0t9ZejqNVEWcGNKBW+8dpFA+NwROQB
 tohmR78jC4Z79gI27+aXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 01/24/2014 01:36 PM, Paolo Bonzini wrote:
> Il 23/01/2014 20:50, Toralf Förster ha scritto: | What makes the
> situation really annyoing - sometimes I just can | restart my wlan
> device it the system works normal, but sometimes | the whole system
> hangs and for those cases then sometimes not even | sysrq buttons
> do work.
> 
> Can you reproduce it with the wlan driver disabled completely?
> 
yes - root cause is not the wlan - that's just a victim.
> Paolo
> 

- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLjiF0ACgkQxOrN3gB26U64DwD/c60zqwUORstYkSD2I1AarWLO
/4QVwWo8hW8bUg6f3SEA/2Wv7jkJTtkfTUVEyZZxeEJaNP+RChsmGSoU77Dl1G7T
=VMnB
-----END PGP SIGNATURE-----
