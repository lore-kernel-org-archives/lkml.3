Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3ANBR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 20:17:28 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54699 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3ANBR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 20:17:27 -0500
Message-ID: <50F35CD3.9080300@gmail.com>
Date: Mon, 14 Jan 2013 09:18:11 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: antoine.trux@gmail.com, fa.linux.kernel@googlegroups.com,
        Johannes Weiner <hannes@saeurebad.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <fa.cHMztHfqJXv7vw5O0nQ8SdTrma0@ifi.uio.no> <fa.V9M+5l8C/um5KEiBtZOjbJDQmu4@ifi.uio.no> <379cc523-8f08-4c7f-ae20-20f216352a01@googlegroups.com> <50F26BE0.7020005@gmail.com> <CAM3j68qo2_Jd=sHBtPaweAwp00N-TYnq8Y1OJZBh3sPfxL3ajw@mail.gmail.com>
In-Reply-To: <CAM3j68qo2_Jd=sHBtPaweAwp00N-TYnq8Y1OJZBh3sPfxL3ajw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060702000001010203040905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060702000001010203040905
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

于 2013年01月14日 04:54, Cong Ding 写道:
> On Sun, Jan 13, 2013 at 9:10 AM, Chen Gang F T
> <chen.gang.flying.transformer@gmail.com> wrote:
>> >   all together:
>> >     kfree() should use 'const void *' as parameter type
>> >     the free() of C Library is incorrect (it use void *).
> you are definitely wrong. both of them are correct - it's the
> difference between kernel space and user space.
> 

  for API features, they are should be no different.

 "- From a very obvious and very *real* caller perspective, 'free()' really 
   doesn't change the thing the pointer points to. It does something 
   totally different: it makes the *pointer* itself invalid."

   "we want the types to be as tight as possible"

  so should use 'const void *' both for 'kfree()' and 'free()' .

-- 
Chen Gang

Flying Transformer

--------------060702000001010203040905
Content-Type: text/x-vcard; charset=utf-8;
 name="chen_gang_flying_transformer.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="chen_gang_flying_transformer.vcf"

YmVnaW46dmNhcmQNCmZuOkNoZW4gR2FuZw0Kbjo7Q2hlbiBHYW5nDQp2ZXJzaW9uOjIuMQ0K
ZW5kOnZjYXJkDQoNCg==
--------------060702000001010203040905--
