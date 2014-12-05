Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaLEOjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:39:25 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24905 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLEOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:39:23 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4f-5481c3987965
Message-id: <5481C32D.5080605@samsung.com>
Date: Fri, 05 Dec 2014 16:37:33 +0200
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
References: <5481A954.1010104@samsung.com> <548172DE.9090007@samsung.com>
 <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
 <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
 <23280.1417775034@warthog.procyon.org.uk>
 <26261.1417788246@warthog.procyon.org.uk>
In-reply-to: <26261.1417788246@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xy7ozDjeGGCx6aGHxruk3i8XsXQ9Z
	LC7vmsNm8aHnEZtFy74LTBY3p11gsfi0YhKzA7vHtBPLWDweHNrM4vF+31U2jxUbTjB7nFlw
	hN3j8ya5ALYoLpuU1JzMstQifbsEroyu8xeYC/bwVMz/cpW5gXETdxcjJ4eEgInEqfXPWCBs
	MYkL99azdTFycQgJLGWUOLF9NiuE08gkMXvaWihnFqPE+WkLGEFaeAW0JG7seAxmswioStw5
	9YQJxGYT0JPY0PyDHcQWFYiQ+LDqKxtEvaDEj8n3wNaJCKhLPFq2kRnEZhZYwigxfWZkFyMH
	h7BAusSLOQoQu6YzSZzveAE2k1PATOLbg09MIDXMQPPvX9SCaJWX2LzmLdgYIaATuteuZYP4
	RlHi9ORzzBMYhWch2TwLoXsWku4FjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULi5usO
	xqXHrA4xCnAwKvHw/ohrDBFiTSwrrsw9xCjBwawkwps8GyjEm5JYWZValB9fVJqTWnyIkYmD
	U6qBkUVzc0XEr6bULfUeltfnVAnuYQn/Jr72X5JYNW+54rWt8XN/qc6vXdEWkdbiZK/PqNJj
	m2M59/nDs1Nanja5ucZl7s5VztBLPCpxlaWO5XPni59bnr66F72hc7NJUMrVR+8Y+tIt2ff/
	efQs5OGN3LrbNbw//n+7YXpa+A9j4EbRaZNfMLy7o8RSnJFoqMVcVJwIAFS4XMV5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 16:04, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> With just "make all" on Ubuntu.
> What gcc?  I don't see any warnings.
>
> David
>

$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.8/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu
4.8.2-19ubuntu1' --with-bugurl=file:///usr/share/doc/gcc-4.8/README.Bugs
--enable-languages=c,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-4.8 --enable-shared --enable-linker-build-id
--libexecdir=/usr/lib --without-included-gettext --enable-threads=posix
--with-gxx-include-dir=/usr/include/c++/4.8 --libdir=/usr/lib
--enable-nls --with-sysroot=/ --enable-clocale=gnu
--enable-libstdcxx-debug --enable-libstdcxx-time=yes
--enable-gnu-unique-object --disable-libmudflap --enable-plugin
--with-system-zlib --disable-browser-plugin --enable-java-awt=gtk
--enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-4.8-amd64/jre
--enable-java-home
--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-4.8-amd64
--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-4.8-amd64
--with-arch-directory=amd64
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc
--enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64
--with-multilib-list=m32,m64,mx32 --with-tune=generic
--enable-checking=release --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 4.8.2 (Ubuntu 4.8.2-19ubuntu1)


