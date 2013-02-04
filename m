Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3BDO43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:56:29 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58381 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:56:28 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <alpine.LFD.2.03.1302011328410.6240@gmail.com>
References: <alpine.LFD.2.03.1302011328410.6240@gmail.com>
Date: Mon, 4 Feb 2013 15:56:27 +0100
Message-ID: <CAJfpegufyY_ZcvKgMVZsLA81ODJwKmStcxDTpObXHfBDRzLKog@mail.gmail.com>
Subject: Re: User-triggerable WARNING with fuse
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tero Roponen <tero.roponen@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae93409c130416204d4e74c46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae93409c130416204d4e74c46
Content-Type: text/plain; charset=UTF-8

On Fri, Feb 1, 2013 at 12:39 PM, Tero Roponen <tero.roponen@gmail.com> wrote:
>
> Using the attached program I can trigger the following WARNING
> reliably as a normal user. This happens at least both in 3.8-rc6
> and 3.7.5.
>
> The kernel is tainted by proprietary NVIDIA module, but I don't
> thinks it matters in this case.
>

Thanks, the attached patch should fix it.

Miklos

--14dae93409c130416204d4e74c46
Content-Type: application/octet-stream; 
	name="fuse-dont-warn-when-nlink-is-zero.patch"
Content-Disposition: attachment; 
	filename="fuse-dont-warn-when-nlink-is-zero.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcrqsm921

RnJvbTogTWlrbG9zIFN6ZXJlZGkgPG1zemVyZWRpQHN1c2UuY3o+ClN1YmplY3Q6IGZ1c2U6IGRv
bid0IFdBUk4gd2hlbiBubGluayBpcyB6ZXJvCgpkcm9wX25saW5rKCkgd2FybnMgaWYgbmxpbmsg
aXMgYWxyZWFkeSB6ZXJvLiAgVGhpcyBpcyB0cmlnZ2VyYWJsZSBieSBhIGJ1Z2d5CnVzZXJzcGFj
ZSBmaWxlc3lzdGVtLiAgVGhlIGN1cmUsIEkgdGhpbmssIGlzIHdvcnNlIHRoYW4gdGhlIGRpc2Vh
c2Ugc28gZGlzYWJsZQp0aGUgd2FybmluZy4KClJlcG9ydGVkLWJ5OiBUZXJvIFJvcG9uZW4gPHRl
cm8ucm9wb25lbkBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IE1pa2xvcyBTemVyZWRpIDxtc3pl
cmVkaUBzdXNlLmN6PgotLS0KIGZzL2Z1c2UvZGlyLmMgfCAgICA5ICsrKysrKysrLQogMSBmaWxl
IGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKLS0tIGEvZnMvZnVzZS9k
aXIuYworKysgYi9mcy9mdXNlL2Rpci5jCkBAIC03MDUsNyArNzA1LDE0IEBAIHN0YXRpYyBpbnQg
ZnVzZV91bmxpbmsoc3RydWN0IGlub2RlICpkaXIKIAogCQlzcGluX2xvY2soJmZjLT5sb2NrKTsK
IAkJZmktPmF0dHJfdmVyc2lvbiA9ICsrZmMtPmF0dHJfdmVyc2lvbjsKLQkJZHJvcF9ubGluayhp
bm9kZSk7CisJCS8qCisJCSAqIElmIGlfbmxpbmsgPT0gMCB0aGVuIHVubGluayBkb2Vzbid0IG1h
a2Ugc2Vuc2UsIHlldCB0aGlzIGNhbgorCQkgKiBoYXBwZW4gaWYgdXNlcnNwYWNlIGZpbGVzeXN0
ZW0gaXMgY2FyZWxlc3MuICBJdCB3b3VsZCBiZQorCQkgKiBkaWZmaWN1bHQgdG8gZW5mb3JjZSBj
b3JyZWN0IG5saW5rIHVzYWdlIHNvIGp1c3QgaWdub3JlIHRoaXMKKwkJICogY29uZGl0aW9uIGhl
cmUKKwkJICovCisJCWlmIChpbm9kZS0+aV9ubGluayA+IDApCisJCQlkcm9wX25saW5rKGlub2Rl
KTsKIAkJc3Bpbl91bmxvY2soJmZjLT5sb2NrKTsKIAkJZnVzZV9pbnZhbGlkYXRlX2F0dHIoaW5v
ZGUpOwogCQlmdXNlX2ludmFsaWRhdGVfYXR0cihkaXIpOwo=
--14dae93409c130416204d4e74c46--
