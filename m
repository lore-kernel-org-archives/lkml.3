Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3ANBpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 20:45:12 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:55254 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3ANBpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 20:45:10 -0500
Message-ID: <50F36352.5080306@gmail.com>
Date: Mon, 14 Jan 2013 09:45:54 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: antoine.trux@gmail.com, fa.linux.kernel@googlegroups.com,
        Johannes Weiner <hannes@saeurebad.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <fa.cHMztHfqJXv7vw5O0nQ8SdTrma0@ifi.uio.no> <fa.V9M+5l8C/um5KEiBtZOjbJDQmu4@ifi.uio.no> <379cc523-8f08-4c7f-ae20-20f216352a01@googlegroups.com> <50F26BE0.7020005@gmail.com> <20130113174105.GA24081@roeck-us.net>
In-Reply-To: <20130113174105.GA24081@roeck-us.net>
Content-Type: multipart/mixed;
 boundary="------------020604070406020207030409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020604070406020207030409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

于 2013年01月14日 01:41, Guenter Roeck 写道:
> Maybe the confusion arises from the somewhat lax use of the term "const
> pointer", and the csomewhat confusing way of defining variable attributes in C.
> Strictly speaking,
> 	const char *name;
> which is identical to
> 	char const *name;
> is not a const pointer, it is a pointer to a constant (string in this case).
> A "const pointer", or "constant pointer to an object", would be
> 	char * const name;

  Maybe.

  :-)

-- 
Chen Gang

Flying Transformer

--------------020604070406020207030409
Content-Type: text/x-vcard; charset=utf-8;
 name="chen_gang_flying_transformer.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="chen_gang_flying_transformer.vcf"

YmVnaW46dmNhcmQNCmZuOkNoZW4gR2FuZw0Kbjo7Q2hlbiBHYW5nDQp2ZXJzaW9uOjIuMQ0K
ZW5kOnZjYXJkDQoNCg==
--------------020604070406020207030409--
