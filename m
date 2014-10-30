Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaJ3AxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:53:16 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47914 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaJ3AxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <5450B55E.6010103@gaast.net>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
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
Date: Wed, 29 Oct 2014 17:53:14 -0700
X-Google-Sender-Auth: wggXiPJfwd6qhTYv93Sd3BQZG_0
Message-ID: <CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a113ee2a02374470506994e5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a113ee2a02374470506994e5a
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 29, 2014 at 2:37 AM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
>
>> Anyway please try attached patched on top of 3.17.
>>
> Done, and that did work! Four suspend+resume cycles later and it's still
> stable.

Then can you test attached simplified one.

--001a113ee2a02374470506994e5a
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_z_yy.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_z_yy.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1vefvk10

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgMTMgKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDEzIGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9wY2kvcGNpLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvcGNpLmMKKysrIGxpbnV4
LTIuNi9kcml2ZXJzL3BjaS9wY2kuYwpAQCAtMTI2NSw2ICsxMjY1LDE5IEBAIHN0YXRpYyB2b2lk
IHBjaV9lbmFibGVfYnJpZGdlKHN0cnVjdCBwY2kKIAlwY2lfc2V0X21hc3RlcihkZXYpOwogfQog
CitzdGF0aWMgdm9pZCBpdGVfc2V0X2QwKHN0cnVjdCBwY2lfZGV2ICpkZXYpCit7CisJaWYgKGRl
di0+cG1fY2FwKSB7CisJCXUxNiBwbWNzcjsKKwkJcGNpX3JlYWRfY29uZmlnX3dvcmQoZGV2LCBk
ZXYtPnBtX2NhcCArIFBDSV9QTV9DVFJMLCAmcG1jc3IpOworCQlkZXYtPmN1cnJlbnRfc3RhdGUg
PSAocG1jc3IgJiBQQ0lfUE1fQ1RSTF9TVEFURV9NQVNLKTsKKwl9CisKKwlwY2lfc2V0X3Bvd2Vy
X3N0YXRlKGRldiwgUENJX0QwKTsKK30KK0RFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5E
T1JfSURfSU5URUwsIDB4MjQ0ZSwgaXRlX3NldF9kMCk7CitERUNMQVJFX1BDSV9GSVhVUF9GSU5B
TChQQ0lfVkVORE9SX0lEX0lURSwgMHg4ODkyLCBpdGVfc2V0X2QwKTsKKwogc3RhdGljIGludCBw
Y2lfZW5hYmxlX2RldmljZV9mbGFncyhzdHJ1Y3QgcGNpX2RldiAqZGV2LCB1bnNpZ25lZCBsb25n
IGZsYWdzKQogewogCXN0cnVjdCBwY2lfZGV2ICpicmlkZ2U7Cg==
--001a113ee2a02374470506994e5a--
