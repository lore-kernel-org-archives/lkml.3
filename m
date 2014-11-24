Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaKXJi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:38:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaKXJi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:38:57 -0500
Message-ID: <5472FCA7.60104@redhat.com>
Date: Mon, 24 Nov 2014 10:38:47 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
References: <20141124171908.034b2fa1@canb.auug.org.au>
In-Reply-To: <20141124171908.034b2fa1@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 24/11/2014 07:19, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (x86_64 
> allmodconfig) failed like this:
> 
> ERROR: "get_xsave_addr" [arch/x86/kvm/kvm.ko] undefined!
> 
> Caused by commit 1d7fe1d1fb18 ("KVM: x86: support XSAVES usage in 
> the host").
> 
> I have used the kvm tree from next-20141121 for today.

Indeed this patch wasn't supposed to be pushed yet.  I will rewind
kvm/next by two commits.  Sorry.

Paolo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUcvyjAAoJEL/70l94x66DqS0H/2KZIYQ2De2dc0xY4tV6fpPV
qHWlQADg4rPJ1Y0nx3f4y3Xbqypp+Jrh9kgc2j3QNj66jcNoE8iYvXTmaCBJx4x8
mex8eurjcP9S+wOHCiWoT/JAnK/jnmkdaxQSWSaGmAaTw+G7Zeui5KUHE/dG9QGK
MNbNJOF1Uksz6Anqd/wNyXAbZcQJAyIiz0sujnOFeZOMG6EY3N9HTYaaYf7hbmtV
q3lZJZOASAOj2+SOWsIaFP6LgcPFW5dQSMpiuZ3aH48VrISHdFnZxoFt5REWiDQZ
ct2HyERItNvjUze/e/b2jjn0KYWswYQgBH7WKUBRvLj291WAepiP8W1dxO2KmaY=
=o6gf
-----END PGP SIGNATURE-----
