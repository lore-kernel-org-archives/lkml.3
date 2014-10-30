Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422678AbaJ3XCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:02:34 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60195 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161370AbaJ3XCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <5452B3A6.7060100@gaast.net>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
	<CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
	<20141022125354.GA3832@gaast.net>
	<CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
	<544E235C.5010908@gaast.net>
	<CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
	<544EC59D.9080303@gaast.net>
	<CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com>
	<544EDD40.1040107@gaast.net>
	<CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
	<545027F9.1040703@gaast.net>
	<CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com>
	<5450B55E.6010103@gaast.net>
	<CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com>
	<545214C5.6070004@gaast.net>
	<CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com>
	<5452B3A6.7060100@gaast.net>
Date: Thu, 30 Oct 2014 16:02:32 -0700
X-Google-Sender-Auth: fJl0BO3gUpAlf2IirK07bYUiRI4
Message-ID: <CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e01184afe1fdf990506abe0f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01184afe1fdf990506abe0f7
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 30, 2014 at 2:54 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:

> http://gaast.net/~wilmer/.lkml/good3.17-patched-megadebug.txt

no difference except on 00:1c.3

--- before.txt    2014-10-30 15:20:35.782886485 -0700
+++ after.txt    2014-10-30 15:21:37.034882515 -0700
@@ -49,10 +49,10 @@
 02f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 0300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 0310: 00 00 00 00 1b 36 3a 74 00 00 14 14 31 17 42 00
-0320: 5b 60 09 00 00 20 00 0a ec 19 b8 04 eb 09 b9 06
+0320: 5b 60 09 00 00 20 00 0a 33 1a b8 04 32 0a 00 07
 0330: 16 00 00 28 bc b5 bc 4a 00 00 00 00 74 4c 85 00
-0340: 33 03 33 00 64 03 3f 00 30 00 0c 00 45 02 b9 00
-0350: 4b 02 c1 00 01 00 08 00 00 00 00 00 00 00 00 00
+0340: 33 03 33 00 64 03 3f 00 30 00 0c 00 46 02 00 00
+0350: 4c 02 08 00 01 00 08 00 00 00 00 00 00 00 00 00
 0360: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 0370: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 0380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Please try attached patch on top of 3.17 without other patches.

If it is working, please dump acpi tables include dsdt.
need to check if there extra work in _PRT.

Thanks

Yinghai

--089e01184afe1fdf990506abe0f7
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_xxx.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_xxx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1wpus7k0

LS0tCiBhcmNoL3g4Ni9wY2kvY29tbW9uLmMgfCAgICA4ICsrKysrKysrCiAxIGZpbGUgY2hhbmdl
ZCwgOCBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L3BjaS9jb21tb24u
Ywo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9wY2kvY29tbW9uLmMKKysr
IGxpbnV4LTIuNi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMKQEAgLTcxOSw2ICs3MTksMTQgQEAgaW50
IHBjaWJpb3NfZW5hYmxlX2RldmljZShzdHJ1Y3QgcGNpX2RldgogCXJldHVybiAwOwogfQogCitz
dGF0aWMgdm9pZCBwY2lfZW5hYmxlX2lycV9pdGUoc3RydWN0IHBjaV9kZXYgKmRldikKK3sKKwlp
ZiAoIXBjaV9kZXZfbXNpX2VuYWJsZWQoZGV2KSkKKwkJcGNpYmlvc19lbmFibGVfaXJxKGRldik7
Cit9CitERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0lOVEVMLCAweDI0NGUs
IHBjaV9lbmFibGVfaXJxX2l0ZSk7CitERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9S
X0lEX0lURSwgMHg4ODkyLCBwY2lfZW5hYmxlX2lycV9pdGUpOworCiB2b2lkIHBjaWJpb3NfZGlz
YWJsZV9kZXZpY2UgKHN0cnVjdCBwY2lfZGV2ICpkZXYpCiB7CiAJaWYgKCFwY2lfZGV2X21zaV9l
bmFibGVkKGRldikgJiYgcGNpYmlvc19kaXNhYmxlX2lycSkK
--089e01184afe1fdf990506abe0f7--
