Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaJaXSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:18:11 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56740 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaJaXSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX7nhBKBGUm6SkWdA3EUm1MZ3rgWf04+AUPAPgSCNam=w@mail.gmail.com>
References: <543F049F.5090605@gaast.net>
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
	<CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com>
	<5452C8BE.3060206@gaast.net>
	<CAE9FiQWd7wC9ijzgObCcGd9QE+U3_wzjQwafXhV=U61hLxGszg@mail.gmail.com>
	<CAE9FiQXPZdYndp6rTKxLUkkwX=AQtRVH3JJC=xzQfsehtBgOqA@mail.gmail.com>
	<545358D5.6070903@gaast.net>
	<CAE9FiQWeZ4AXwwT=NS96Q+FxPz+3Bj5rf8JoRDmJ-RHBhjj78g@mail.gmail.com>
	<5453FB8E.8050506@gaast.net>
	<CAE9FiQX7nhBKBGUm6SkWdA3EUm1MZ3rgWf04+AUPAPgSCNam=w@mail.gmail.com>
Date: Fri, 31 Oct 2014 16:18:08 -0700
X-Google-Sender-Auth: ewTr6BGdMd1rBcV5MaRZCmAF9vw
Message-ID: <CAE9FiQVQK4aa9bW3d3=rw+hgogSFuKnwFSutSqcMrmCCc9_3dw@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c2fc1ab6d8980506c0358f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2fc1ab6d8980506c0358f
Content-Type: text/plain; charset=UTF-8

On Fri, Oct 31, 2014 at 2:22 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Oct 31, 2014 at 2:13 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
>> On 31-10-14 16:11, Yinghai Lu wrote:
>>>
>>>
>>> Good. Please check if attached one on top of 3.17 only would work too.
>>>
>> No luck, sadly. :-( Unsuccessful third resume.

Please try attached two patches separately on top of 3.17.

--001a11c2fc1ab6d8980506c0358f
Content-Type: text/x-patch; charset=US-ASCII; name="pci_enable_bridge_ite.patch"
Content-Disposition: attachment; filename="pci_enable_bridge_ite.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1y5v7qa0

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgMTggKysrKysrKysrKysrKysrKysrCiAxIGZpbGUg
Y2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9w
Y2kuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9wY2kuYworKysg
bGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS5jCkBAIC0xMjY1LDYgKzEyNjUsMjQgQEAgc3RhdGlj
IHZvaWQgcGNpX2VuYWJsZV9icmlkZ2Uoc3RydWN0IHBjaQogCXBjaV9zZXRfbWFzdGVyKGRldik7
CiB9CiAKK3N0YXRpYyB2b2lkIHBjaV9lbmFibGVfaXRlKHN0cnVjdCBwY2lfZGV2ICpkZXYpCit7
CisJLyoKKwkgKiBGVyBlbmFibGUgdGhlIGJyaWRnZSBhbHJlYWR5LCBzbyBjYWxsIHBjaV9lbmFi
bGVfYnJpZGdlKCkKKwkgKiB0byBrZWVwIGVuYWJsZV9jbnQgY29uc2lzdGVudCwgdGhlbiBsYXRl
ciB3ZSBjYW4gZ28gdGhyb3VnaAorCSAqIHBjaV9wbV9yZXN1bWUvcGNpX3BtX3JlZW5hYmxlX2Rl
dmljZSB0byBlbmFibGUgaXQgYWdhaW4uCisJICogLS0tIGZvciBwY2kgYnJpZGdlIHdpdGhvdXQg
ZHJpdmVyIGNhc2UuCisJICovCisgICAgICAgIGlmICghcGNpX2lzX2VuYWJsZWQoZGV2KSkgewor
CQl1MTYgY21kOworCisJCXBjaV9yZWFkX2NvbmZpZ193b3JkKGRldiwgUENJX0NPTU1BTkQsICZj
bWQpOworCQlpZiAoKGNtZCAmIChQQ0lfQ09NTUFORF9JTyB8fCBQQ0lfQ09NTUFORF9NRU1PUlkp
KSAmJgorCQkJcGNpX2VuYWJsZV9icmlkZ2UoZGV2KTsKKwl9Cit9CitERUNMQVJFX1BDSV9GSVhV
UF9GSU5BTChQQ0lfVkVORE9SX0lEX0lURSwgMHg4ODkyLCBwY2lfZW5hYmxlX2l0ZSk7CisKIHN0
YXRpYyBpbnQgcGNpX2VuYWJsZV9kZXZpY2VfZmxhZ3Moc3RydWN0IHBjaV9kZXYgKmRldiwgdW5z
aWduZWQgbG9uZyBmbGFncykKIHsKIAlzdHJ1Y3QgcGNpX2RldiAqYnJpZGdlOwo=
--001a11c2fc1ab6d8980506c0358f
Content-Type: text/x-patch; charset=US-ASCII; name="pci_pm_reenable_device_enhance.patch"
Content-Disposition: attachment; 
	filename="pci_pm_reenable_device_enhance.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1y5vdit1

LS0tCiBkcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMgfCAgICA5ICsrKysrKysrKwogMSBmaWxlIGNo
YW5nZWQsIDkgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wY2kt
ZHJpdmVyLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvcGNpLWRy
aXZlci5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9wY2kvcGNpLWRyaXZlci5jCkBAIC01MTksOCAr
NTE5LDE3IEBAIHN0YXRpYyB2b2lkIHBjaV9wbV9zZXRfdW5rbm93bl9zdGF0ZShzdHIKICAqLwog
c3RhdGljIGludCBwY2lfcG1fcmVlbmFibGVfZGV2aWNlKHN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2
KQogeworCXUxNiBjbWQ7CiAJaW50IHJldHZhbDsKIAorCS8qIHVwZGF0ZSBlbmFibGVfY250IGFj
Y29yZGluZyB0byBjbWQgcmVnaXN0ZXIgKi8KKwlwY2lfcmVhZF9jb25maWdfd29yZChwY2lfZGV2
LCBQQ0lfQ09NTUFORCwgJmNtZCk7CisJaWYgKCFwY2lfZGV2LT5pc19idXNtYXN0ZXIgJiYgKGNt
ZCAmIFBDSV9DT01NQU5EX01BU1RFUikpCisJCXBjaV9kZXYtPmlzX2J1c21hc3RlciA9IHRydWU7
CisJaWYgKCFwY2lfaXNfZW5hYmxlZChwY2lfZGV2KSAmJgorCSAgICAoY21kICYgKFBDSV9DT01N
QU5EX0lPIHwgUENJX0NPTU1BTkRfTUVNT1JZKSkpCisJCWF0b21pY19pbmMoJnBjaV9kZXYtPmVu
YWJsZV9jbnQpOworCiAJLyogaWYgdGhlIGRldmljZSB3YXMgZW5hYmxlZCBiZWZvcmUgc3VzcGVu
ZCwgcmVlbmFibGUgKi8KIAlyZXR2YWwgPSBwY2lfcmVlbmFibGVfZGV2aWNlKHBjaV9kZXYpOwog
CS8qCg==
--001a11c2fc1ab6d8980506c0358f--
