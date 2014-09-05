Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaIEBTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:19:18 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57373 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbaIEBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140904212925.GL3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
	<20140904100137.GK3001@console-pimps.org>
	<5408D299.5000300@zytor.com>
	<20140904212925.GL3001@console-pimps.org>
Date: Thu, 4 Sep 2014 18:19:16 -0700
X-Google-Sender-Auth: EgquqP6F63Z8j53o6pbA1BGVvOg
Message-ID: <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt@console-pimps.org>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laszlo Ersek <lersek@redhat.com>
Content-Type: multipart/mixed; boundary=001a11c3bf04f9218d0502474180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c3bf04f9218d0502474180
Content-Type: text/plain; charset=UTF-8

On Thu, Sep 4, 2014 at 2:29 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
>>
>> I am fine with this patch, but at the same time I do want to note that
>> there is an alternative to double-buffer the patch and/or (if that
>> applies to the buggy BIOS) round up the size of the target buffer.
>
> I'm not sure that rounding up the size of the target buffer will
> workaround this issue correctly.
>
> As far as I know, the only thing that Mantas tried was rounding up the
> size of the source file, by padding it.

Hi Mantas,

Can you try attached patch on top of linus tree?

Thanks

Yinghai

--001a11c3bf04f9218d0502474180
Content-Type: text/x-patch; charset=US-ASCII; name="round_up_chunksize.patch"
Content-Disposition: attachment; filename="round_up_chunksize.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hzou2nyd0

LS0tCiBkcml2ZXJzL2Zpcm13YXJlL2VmaS9saWJzdHViL2VmaS1zdHViLWhlbHBlci5jIHwgICAg
MiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRl
eDogbGludXgtMi42L2RyaXZlcnMvZmlybXdhcmUvZWZpL2xpYnN0dWIvZWZpLXN0dWItaGVscGVy
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9maXJtd2FyZS9lZmkvbGli
c3R1Yi9lZmktc3R1Yi1oZWxwZXIuYworKysgbGludXgtMi42L2RyaXZlcnMvZmlybXdhcmUvZWZp
L2xpYnN0dWIvZWZpLXN0dWItaGVscGVyLmMKQEAgLTQyNiw3ICs0MjYsNyBAQCBlZmlfc3RhdHVz
X3QgaGFuZGxlX2NtZGxpbmVfZmlsZXMoZWZpX3N5CiAJCQkJaWYgKHNpemUgPiBFRklfUkVBRF9D
SFVOS19TSVpFKQogCQkJCQljaHVua3NpemUgPSBFRklfUkVBRF9DSFVOS19TSVpFOwogCQkJCWVs
c2UKLQkJCQkJY2h1bmtzaXplID0gc2l6ZTsKKwkJCQkJY2h1bmtzaXplID0gcm91bmRfdXAoc2l6
ZSwgRUZJX1BBR0VfU0laRSk7CiAKIAkJCQlzdGF0dXMgPSBlZmlfZmlsZV9yZWFkKGZpbGVzW2pd
LmhhbmRsZSwKIAkJCQkJCSAgICAgICAmY2h1bmtzaXplLAo=
--001a11c3bf04f9218d0502474180--
