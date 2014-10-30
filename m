Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbaJ3Q5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:57:43 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44191 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbaJ3Q5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <545214C5.6070004@gaast.net>
References: <543F049F.5090605@gaast.net>
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
	<CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com>
	<545214C5.6070004@gaast.net>
Date: Thu, 30 Oct 2014 09:57:40 -0700
X-Google-Sender-Auth: icWrgM6hhBnizzSnN2kfwtgzaV8
Message-ID: <CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a1142dd643d32f50506a6c71b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1142dd643d32f50506a6c71b
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 30, 2014 at 3:36 AM, Wilmer van der Gaast <wilmer@gaast.net> wrote:

> Sadly, with that patch (applied against a vanilla 3.17 tree like all the> others) the second resume fails already. :-(

oh, no. Really want to know which bit causes the problem.

Please check debug patch...that will print out pci conf space before
...and after...

--001a1142dd643d32f50506a6c71b
Content-Type: text/x-patch; charset=US-ASCII; name="debug_extra_dump_pci.patch"
Content-Disposition: attachment; filename="debug_extra_dump_pci.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1wcu2d90

U3ViamVjdDogW1BBVENIXSBwY2k6IHByaW50IG91dCBhYm91dCBwY2k9ZHVtcAoKZGVidWcgcHJp
bnQgb3V0IGJlZm9yZSBsYXRlciBkcml2ZXIgaGFuZwoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBM
dSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgNTIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxl
IGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCkluZGV4OiBsaW51eC0y
LjYvZHJpdmVycy9wY2kvcGNpLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVy
cy9wY2kvcGNpLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wY2kuYwpAQCAtMzg1OCw2ICsz
ODU4LDU0IEBAIHZvaWQgX193ZWFrIHBjaV9maXh1cF9jYXJkYnVzKHN0cnVjdCBwY2kKIH0KIEVY
UE9SVF9TWU1CT0wocGNpX2ZpeHVwX2NhcmRidXMpOwogCitzdGF0aWMgdm9pZCBkdW1wX3BjaV9k
ZXZpY2VfcmFuZ2Uoc3RydWN0IHBjaV9kZXYgKmRldiwgdW5zaWduZWQgc3RhcnRfcmVnLAorCQkJ
CQkgdW5zaWduZWQgc2l6ZSkKK3sKKwlpbnQgaTsKKwlpbnQgajsKKwl1MzIgdmFsOworCWludCBl
bmQgPSBzdGFydF9yZWcgKyBzaXplOworCisJcHJpbnRrKEtFUk5fREVCVUcgIlBDSTogJXMiLCBw
Y2lfbmFtZShkZXYpKTsKKworCWZvciAoaSA9IHN0YXJ0X3JlZzsgaSA8IGVuZDsgaSArPSA0KSB7
CisJCWlmICghKGkgJiAweDBmKSkKKwkJCXByaW50aygiXG4lMDR4OiIsIGkpOworCisJCXBjaV9y
ZWFkX2NvbmZpZ19kd29yZChkZXYsIGksICZ2YWwpOworCQlmb3IgKGogPSAwOyBqIDwgNDsgaisr
KSB7CisJCQlwcmludGsoIiAlMDJ4IiwgdmFsICYgMHhmZik7CisJCQl2YWwgPj49IDg7CisJCX0K
Kwl9CisJcHJpbnRrKCJcbiIpOworfQorCitzdGF0aWMgaW50IGR1bXBfcGNpX2RldmljZXModm9p
ZCkKK3sKKwlzdHJ1Y3QgcGNpX2RldiAqZGV2ID0gTlVMTDsKKworCXdoaWxlICgoZGV2ID0gcGNp
X2dldF9kZXZpY2UoUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgZGV2KSkgIT0gTlVMTCkKKwkJZHVt
cF9wY2lfZGV2aWNlX3JhbmdlKGRldiwgMCwgZGV2LT5jZmdfc2l6ZSk7CisKKwlyZXR1cm4gMDsK
K30KKworc3RhdGljIGludCBwY2lfZHVtcF9yZWdzOworc3RhdGljIHZvaWQgcGNpX2R1bXAodm9p
ZCkKK3sKKwlwY2lfZHVtcF9yZWdzID0gMTsKK30KKworc3RhdGljIGludCBwY2lfaW5pdCh2b2lk
KQoreworCWlmIChwY2lfZHVtcF9yZWdzKQorCQlkdW1wX3BjaV9kZXZpY2VzKCk7CisKKwlyZXR1
cm4gMDsKK30KK2RldmljZV9pbml0Y2FsbChwY2lfaW5pdCk7CisKIHN0YXRpYyBpbnQgX19pbml0
IHBjaV9zZXR1cChjaGFyICpzdHIpCiB7CiAJd2hpbGUgKHN0cikgewpAQCAtMzg2NSw3ICszOTEz
LDkgQEAgc3RhdGljIGludCBfX2luaXQgcGNpX3NldHVwKGNoYXIgKnN0cikKIAkJaWYgKGspCiAJ
CQkqaysrID0gMDsKIAkJaWYgKCpzdHIgJiYgKHN0ciA9IHBjaWJpb3Nfc2V0dXAoc3RyKSkgJiYg
KnN0cikgewotCQkJaWYgKCFzdHJjbXAoc3RyLCAibm9tc2kiKSkgeworCQkJaWYgKCFzdHJjbXAo
c3RyLCAiZHVtcCIpKSB7CisJCQkJcGNpX2R1bXAoKTsKKwkJCX0gZWxzZSBpZiAoIXN0cmNtcChz
dHIsICJub21zaSIpKSB7CiAJCQkJcGNpX25vX21zaSgpOwogCQkJfSBlbHNlIGlmICghc3RyY21w
KHN0ciwgIm5vYWVyIikpIHsKIAkJCQlwY2lfbm9fYWVyKCk7Cg==
--001a1142dd643d32f50506a6c71b
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_z_zz.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_z_zz.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1wcudh31

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgMTQgKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFu
Z2VkLCAxNCBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS5j
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3BjaS5jCisrKyBsaW51
eC0yLjYvZHJpdmVycy9wY2kvcGNpLmMKQEAgLTEyNjUsNiArMTI2NSwyMCBAQCBzdGF0aWMgdm9p
ZCBwY2lfZW5hYmxlX2JyaWRnZShzdHJ1Y3QgcGNpCiAJcGNpX3NldF9tYXN0ZXIoZGV2KTsKIH0K
IAorc3RhdGljIGludCBkdW1wX3BjaV9kZXZpY2VzKHZvaWQpOworCitzdGF0aWMgdm9pZCBwY2lf
ZW5hYmxlX2l0ZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQoreworCXByX2luZm8oImJlZm9yZS4uLlxu
Iik7CisJZHVtcF9wY2lfZGV2aWNlcygpOworCisJcGNpX2VuYWJsZV9icmlkZ2UoZGV2KTsKKwor
CXByX2luZm8oImFmdGVyLi4uXG4iKTsKKwlkdW1wX3BjaV9kZXZpY2VzKCk7Cit9CitERUNMQVJF
X1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0lURSwgMHg4ODkyLCBwY2lfZW5hYmxlX2l0
ZSk7CisKIHN0YXRpYyBpbnQgcGNpX2VuYWJsZV9kZXZpY2VfZmxhZ3Moc3RydWN0IHBjaV9kZXYg
KmRldiwgdW5zaWduZWQgbG9uZyBmbGFncykKIHsKIAlzdHJ1Y3QgcGNpX2RldiAqYnJpZGdlOwo=
--001a1142dd643d32f50506a6c71b--
