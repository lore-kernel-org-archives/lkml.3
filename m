Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaLEMvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:51:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18918 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLEMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:51:20 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-48-5481aa4681f9
Message-id: <5481A9DB.60703@samsung.com>
Date: Fri, 05 Dec 2014 14:49:31 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, mmarek@suse.cz, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 4/5] MODSIGN: Provide a utility to append a PKCS#7
 signature to a module [ver #2]
References: <548172DE.9090007@samsung.com>
 <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
 <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
 <23280.1417775034@warthog.procyon.org.uk> <5481A954.1010104@samsung.com>
In-reply-to: <5481A954.1010104@samsung.com>
Content-type: multipart/mixed; boundary=------------050507010703020805020209
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xy7puqxpDDLatY7Z41/SbxWL2rocs
	Fpd3zWGz+NDziM2iZd8FJoub0y6wWHxaMYnZgd1j2ollLB4PDm1m8Xi/7yqbx4oNJ5g9ziw4
	wu7xeZNcAFsUl01Kak5mWWqRvl0CV8befSuZCt5pVmw49ZupgfGIShcjB4eEgInE1q1aXYyc
	QKaYxIV769m6GLk4hASWMkpMPvWRFSQhJNDIJLFuqzpEYhajxLlJX9lAErwCGhKb3l1hBrFZ
	BFQlDjyewAJiswnoSWxo/sEOYosKREh8WAVTLyjxY/I9sBoRAXWJR8s2gvUyCyxhlJg+MxLk
	IGGBdIkXcxQgdr1mlPjyfwUTSA2ngLbEx0Pz2EBqmAV8JJbPd4S4TVWie+1aNogHFCVOTz7H
	PIFRaBaSbbMQOmaBLTOQOLJoDiuELS+x/e0cZgjbQWLhm9dMmOJWEhf73jMvYGRfxSiaWppc
	UJyUnmuoV5yYW1yal66XnJ+7iRESe192MC4+ZnWIUYCDUYmH94J1Y4gQa2JZcWXuIUYVoDmP
	Nqy+wCjFkpefl6okwps8GyjNm5JYWZValB9fVJqTWnyIkYmDU6qBUakz8e/H3pOfzUWLKjYu
	kKg10Jh3cN/3u9+MDLZNVblmW9HuffUN35y9DpKnPh49klKnyPBG4ZVUe3JN5nFG25ILm659
	PhnGNfto9PJzdTdsLBmlNVxM/Nx7mbp/mgfNuPzLqtIp/dlOo740ze/zvzb2Mb5fIeFn8C/h
	HEeBilbTjJumRvtOKbEUZyQaajEXFScCAFgZVfunAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050507010703020805020209
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit

On 05/12/14 14:47, Dmitry Kasatkin wrote:
> On 05/12/14 12:23, David Howells wrote:
>> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>>
>>> sign-file.c produce lots of annoying noise.
>> How did you get it to produce that?
>>
>> David
>>
> With just "make all" on Ubuntu.
>
>
> - Dmitry
>

See command line in attached file...

- Dmitry


--------------050507010703020805020209
Content-Type: text/plain; charset="UTF-8"; name=".sign-file.cmd"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=".sign-file.cmd"

cmd_scripts/sign-file := gcc -Wp,-MD,scripts/.sign-file.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -I./tools/include  -o scripts/sign-file scripts/sign-file.c  -lcrypto

source_scripts/sign-file := scripts/sign-file.c

deps_scripts/sign-file := \
  /usr/include/stdc-predef.h \
  /usr/include/stdio.h \
  /usr/include/features.h \
  /usr/include/x86_64-linux-gnu/sys/cdefs.h \
  /usr/include/x86_64-linux-gnu/bits/wordsize.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs-64.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.8/include/stddef.h \
  /usr/include/x86_64-linux-gnu/bits/types.h \
  /usr/include/x86_64-linux-gnu/bits/typesizes.h \
  /usr/include/libio.h \
  /usr/include/_G_config.h \
  /usr/include/wchar.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.8/include/stdarg.h \
  /usr/include/x86_64-linux-gnu/bits/stdio_lim.h \
  /usr/include/x86_64-linux-gnu/bits/sys_errlist.h \
  /usr/include/x86_64-linux-gnu/bits/stdio.h \
  /usr/include/x86_64-linux-gnu/bits/stdio2.h \
  /usr/include/stdlib.h \
  /usr/include/x86_64-linux-gnu/bits/waitflags.h \
  /usr/include/x86_64-linux-gnu/bits/waitstatus.h \
  /usr/include/endian.h \
  /usr/include/x86_64-linux-gnu/bits/endian.h \
  /usr/include/x86_64-linux-gnu/bits/byteswap.h \
  /usr/include/x86_64-linux-gnu/bits/byteswap-16.h \
  /usr/include/xlocale.h \
  /usr/include/x86_64-linux-gnu/sys/types.h \
  /usr/include/time.h \
  /usr/include/x86_64-linux-gnu/sys/select.h \
  /usr/include/x86_64-linux-gnu/bits/select.h \
  /usr/include/x86_64-linux-gnu/bits/sigset.h \
  /usr/include/x86_64-linux-gnu/bits/time.h \
  /usr/include/x86_64-linux-gnu/bits/select2.h \
  /usr/include/x86_64-linux-gnu/sys/sysmacros.h \
  /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h \
  /usr/include/alloca.h \
  /usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h \
  /usr/include/x86_64-linux-gnu/bits/stdlib-float.h \
  /usr/include/x86_64-linux-gnu/bits/stdlib.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.8/include/stdint.h \
  /usr/include/stdint.h \
  /usr/include/x86_64-linux-gnu/bits/wchar.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.8/include/stdbool.h \
  /usr/include/string.h \
  /usr/include/x86_64-linux-gnu/bits/string.h \
  /usr/include/x86_64-linux-gnu/bits/string2.h \
  /usr/include/x86_64-linux-gnu/bits/string3.h \
  /usr/include/getopt.h \
  /usr/include/err.h \
  /usr/include/arpa/inet.h \
  /usr/include/netinet/in.h \
  /usr/include/x86_64-linux-gnu/sys/socket.h \
  /usr/include/x86_64-linux-gnu/sys/uio.h \
  /usr/include/x86_64-linux-gnu/bits/uio.h \
  /usr/include/x86_64-linux-gnu/bits/socket.h \
  /usr/include/x86_64-linux-gnu/bits/socket_type.h \
  /usr/include/x86_64-linux-gnu/bits/sockaddr.h \
  /usr/include/x86_64-linux-gnu/asm/socket.h \
  /usr/include/asm-generic/socket.h \
  /usr/include/x86_64-linux-gnu/asm/sockios.h \
  /usr/include/asm-generic/sockios.h \
  /usr/include/x86_64-linux-gnu/bits/socket2.h \
  /usr/include/x86_64-linux-gnu/bits/in.h \
  /usr/include/openssl/bio.h \
  /usr/include/openssl/e_os2.h \
  /usr/include/x86_64-linux-gnu/openssl/opensslconf.h \
    $(wildcard include/config/header/bn/h.h) \
    $(wildcard include/config/header/rc4/locl/h.h) \
    $(wildcard include/config/header/bf/locl/h.h) \
    $(wildcard include/config/header/des/locl/h.h) \
  /usr/include/openssl/crypto.h \
  /usr/include/openssl/stack.h \
  /usr/include/openssl/safestack.h \
  /usr/include/openssl/opensslv.h \
  /usr/include/openssl/ossl_typ.h \
  /usr/include/openssl/symhacks.h \
  /usr/include/openssl/evp.h \
  /usr/include/openssl/objects.h \
  /usr/include/openssl/obj_mac.h \
  /usr/include/openssl/asn1.h \
  /usr/include/x86_64-linux-gnu/bits/timex.h \
  /usr/include/openssl/bn.h \
  /usr/include/openssl/pem.h \
  /usr/include/openssl/x509.h \
  /usr/include/openssl/buffer.h \
  /usr/include/openssl/ec.h \
  /usr/include/openssl/ecdsa.h \
  /usr/include/openssl/ecdh.h \
  /usr/include/openssl/rsa.h \
  /usr/include/openssl/dsa.h \
  /usr/include/openssl/dh.h \
  /usr/include/openssl/sha.h \
  /usr/include/openssl/x509_vfy.h \
  /usr/include/openssl/lhash.h \
  /usr/include/openssl/pkcs7.h \
  /usr/include/openssl/pem2.h \
  /usr/include/openssl/err.h \
  /usr/include/errno.h \
  /usr/include/x86_64-linux-gnu/bits/errno.h \
  /usr/include/linux/errno.h \
  /usr/include/x86_64-linux-gnu/asm/errno.h \
  /usr/include/asm-generic/errno.h \
  /usr/include/asm-generic/errno-base.h \

scripts/sign-file: $(deps_scripts/sign-file)

$(deps_scripts/sign-file):

--------------050507010703020805020209--
