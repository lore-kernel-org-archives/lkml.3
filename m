Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbbAIL5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:57:19 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37076 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbAIL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:57:16 -0500
MIME-Version: 1.0
Date: Fri, 9 Jan 2015 13:57:14 +0200
X-Google-Sender-Auth: OZgzIPHyDKnTuvZncnSu4DKzPPU
Message-ID: <CAEnQRZDKhgSV=+P_M9aJP-+8DftxVmjgHgAR7OAxFUku6RHsHw@mail.gmail.com>
Subject: checkpatch wrong error message
From: Daniel Baluta <daniel.baluta@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f3b9daf8abd61050c36db6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f3b9daf8abd61050c36db6b
Content-Type: text/plain; charset=UTF-8

Hi Joe,

Running ./scripts/checkpatch on the attached [1] patch i get the
following error:

ERROR: Please use 12 or more chars for the git commit ID like: 'commit
01234567890ab ("commit description")'
#6:
After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is

total: 1 errors, 0 warnings, 16 lines checked

0001-iio-kmx61-PM-Replace-CONFIG_PM_RUNTIME-with-CONFIG_P.patch has
style problems, please review.

As you can see b2b49ccbdd54 is exactly 12 chars so there shouldn't be
an error report.

Also example git ID is wrong 01234567890ab (13 chars) should be
0123456789ab (12 chars).

thanks,
Daniel.

[1] http://marc.info/?l=linux-iio&m=142079625602634&w=2

--e89a8f3b9daf8abd61050c36db6b
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-iio-kmx61-PM-Replace-CONFIG_PM_RUNTIME-with-CONFIG_P.patch"
Content-Disposition: attachment; 
	filename="0001-iio-kmx61-PM-Replace-CONFIG_PM_RUNTIME-with-CONFIG_P.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4pib9xo0

RnJvbSAwZjlmYjc4MjExZDczNDg0YTRlOTE5ZDM2OTZmMjM1OGQyMGU5YzJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW5pZWwgQmFsdXRhIDxkYW5pZWwuYmFsdXRhQGludGVsLmNv
bT4KRGF0ZTogRnJpLCA5IEphbiAyMDE1IDExOjE3OjI3ICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
aWlvIGtteDYxIC8gUE06IFJlcGxhY2UgQ09ORklHX1BNX1JVTlRJTUUgd2l0aCBDT05GSUdfUE0K
CkFmdGVyIGNvbW1pdCBiMmI0OWNjYmRkNTQgKFBNOiBLY29uZmlnOiBTZXQgUE1fUlVOVElNRSBp
ZiBQTV9TTEVFUCBpcwpzZWxlY3RlZCkgUE1fUlVOVElNRSBpcyBhbHdheXMgc2V0IGlmIFBNIGlz
IHNldCwgc28gI2lmZGVmIGJsb2NrcwpkZXBlbmRpbmcgb24gQ09ORklHX1BNX1JVTlRJTUUgbWF5
IG5vdyBiZSBjaGFuZ2VkIHRvIGRlcGVuZCBvbgpDT05GSUdfUE0uCgpSZXBsYWNlIENPTkZJR19Q
TV9SVU5USU1FIHdpdGggQ09ORklHX1BNIGV2ZXJ5d2hlcmUgdW5kZXIKZHJpdmVycy9paW8vaW11
L2tteDYxLmMKClNpZ25lZC1vZmYtYnk6IERhbmllbCBCYWx1dGEgPGRhbmllbC5iYWx1dGFAaW50
ZWwuY29tPgotLS0KIGRyaXZlcnMvaWlvL2ltdS9rbXg2MS5jIHwgNCArKy0tCiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvaWlvL2ltdS9rbXg2MS5jIGIvZHJpdmVycy9paW8vaW11L2tteDYxLmMKaW5kZXggNjE3OGNl
YS4uYTY4MmRkMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9paW8vaW11L2tteDYxLmMKKysrIGIvZHJp
dmVycy9paW8vaW11L2tteDYxLmMKQEAgLTczNSw3ICs3MzUsNyBAQCBzdGF0aWMgaW50IGtteDYx
X3NldHVwX2FueV9tb3Rpb25faW50ZXJydXB0KHN0cnVjdCBrbXg2MV9kYXRhICpkYXRhLAogICov
CiBzdGF0aWMgaW50IGtteDYxX3NldF9wb3dlcl9zdGF0ZShzdHJ1Y3Qga214NjFfZGF0YSAqZGF0
YSwgYm9vbCBvbiwgdTggZGV2aWNlKQogewotI2lmZGVmIENPTkZJR19QTV9SVU5USU1FCisjaWZk
ZWYgQ09ORklHX1BNCiAJaW50IHJldDsKIAogCWlmIChkZXZpY2UgJiBLTVg2MV9BQ0MpIHsKQEAg
LTE1MjMsNyArMTUyMyw3IEBAIHN0YXRpYyBpbnQga214NjFfcmVzdW1lKHN0cnVjdCBkZXZpY2Ug
KmRldikKIH0KICNlbmRpZgogCi0jaWZkZWYgQ09ORklHX1BNX1JVTlRJTUUKKyNpZmRlZiBDT05G
SUdfUE0KIHN0YXRpYyBpbnQga214NjFfcnVudGltZV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRl
dikKIHsKIAlzdHJ1Y3Qga214NjFfZGF0YSAqZGF0YSA9IGkyY19nZXRfY2xpZW50ZGF0YSh0b19p
MmNfY2xpZW50KGRldikpOwotLSAKMS45LjEKCg==
--e89a8f3b9daf8abd61050c36db6b--
