Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaL0UTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:19:52 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58075 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaL0UTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:19:50 -0500
MIME-Version: 1.0
In-Reply-To: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>
References: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>
Date: Sat, 27 Dec 2014 21:19:49 +0100
Message-ID: <CACna6rxjrcpZXiv0jxmY4+EtLESYtKh=6W2RgqUDLHYy3AQ4rA@mail.gmail.com>
Subject: Re: [PATCH] bcma: fix three coding style issues, more than 80
 characters per line
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11407980019e26050b385db4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11407980019e26050b385db4
Content-Type: text/plain; charset=UTF-8

On 27 December 2014 at 20:24, Oscar Forner Martinez
<oscar.forner.martinez@gmail.com> wrote:
> Three lines with more than 80 characters per line have been split in several lines.

Thanks for the next version :)

1) You missed version number. Something like
git format-patch --subject-prefix="PATCH V3"
(you saying for the future).

2) I'm OK with your changes, but when checking the patch I get some errors like
ERROR: trailing whitespace
ERROR: DOS line endings
(I used ./scripts/checkpatch.pl, see attached checkpatch log).

I think that "trailing whitespace" errors are caused by DOS line
endings, because I don't see anything wrong about your code.

Is there something wrong with your emacs? git-send-email shouldn't
malform patches I believe.

--001a11407980019e26050b385db4
Content-Type: text/plain; charset=US-ASCII; name="bcma.checkpatch.txt"
Content-Disposition: attachment; filename="bcma.checkpatch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i47fj1cu0

RVJST1I6IHRyYWlsaW5nIHdoaXRlc3BhY2UKIzYyOiBGSUxFOiBkcml2ZXJzL2JjbWEvZHJpdmVy
X2NoaXBjb21tb24uYzo4MjoKK15JXkleSS8qIDQ3MDYgQ0MgYW5kIFBNVSB3YXRjaGRvZ3MgYXJl
IGNsb2NrZWQgYXQgMS80IG9mIEFMUF5NJAoKRVJST1I6IHRyYWlsaW5nIHdoaXRlc3BhY2UKIzYz
OiBGSUxFOiBkcml2ZXJzL2JjbWEvZHJpdmVyX2NoaXBjb21tb24uYzo4MzoKK15JXkleSSAqIGNs
b2NrXk0kCgpFUlJPUjogRE9TIGxpbmUgZW5kaW5ncwojNjQ6IEZJTEU6IGRyaXZlcnMvYmNtYS9k
cml2ZXJfY2hpcGNvbW1vbi5jOjg0OgorXkleSV5JICovXk0kCgpFUlJPUjogRE9TIGxpbmUgZW5k
aW5ncwojNzM6IEZJTEU6IGRyaXZlcnMvYmNtYS9kcml2ZXJfY2hpcGNvbW1vbi5jOjEwMjoKK15J
d2R0Lm1heF90aW1lcl9tcyA9Xk0kCgpFUlJPUjogRE9TIGxpbmUgZW5kaW5ncwojNzQ6IEZJTEU6
IGRyaXZlcnMvYmNtYS9kcml2ZXJfY2hpcGNvbW1vbi5jOjEwMzoKK15JXkliY21hX2NoaXBjb193
YXRjaGRvZ19nZXRfbWF4X3RpbWVyKGNjKSAvIGNjLT50aWNrc19wZXJfbXM7Xk0kCgpFUlJPUjog
RE9TIGxpbmUgZW5kaW5ncwojODM6IEZJTEU6IGRyaXZlcnMvYmNtYS9kcml2ZXJfY2hpcGNvbW1v
bi5jOjM0MToKK15JXkliY21hX2VycihjYy0+Y29yZS0+YnVzLCAic2VyaWFsIG5vdCBzdXBwb3J0
ZWQgb24gdGhpcyBkZXZpY2UgY2NyZXY6IDB4JXhcbiIsXk0kCgpFUlJPUjogRE9TIGxpbmUgZW5k
aW5ncwojODQ6IEZJTEU6IGRyaXZlcnMvYmNtYS9kcml2ZXJfY2hpcGNvbW1vbi5jOjM0MjoKK15J
XkleSSBjY3Jldik7Xk0kCgp0b3RhbDogNyBlcnJvcnMsIDAgd2FybmluZ3MsIDI4IGxpbmVzIGNo
ZWNrZWQKCk5PVEU6IHdoaXRlc3BhY2UgZXJyb3JzIGRldGVjdGVkLCB5b3UgbWF5IHdpc2ggdG8g
dXNlIHNjcmlwdHMvY2xlYW5wYXRjaCBvcgogICAgICBzY3JpcHRzL2NsZWFuZmlsZQoKYmNtYS5w
YXRjaCBoYXMgc3R5bGUgcHJvYmxlbXMsIHBsZWFzZSByZXZpZXcuCgpJZiBhbnkgb2YgdGhlc2Ug
ZXJyb3JzIGFyZSBmYWxzZSBwb3NpdGl2ZXMsIHBsZWFzZSByZXBvcnQKdGhlbSB0byB0aGUgbWFp
bnRhaW5lciwgc2VlIENIRUNLUEFUQ0ggaW4gTUFJTlRBSU5FUlMuCg==
--001a11407980019e26050b385db4--
