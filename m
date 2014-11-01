Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaKACKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:10:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35411 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKACKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:10:30 -0400
MIME-Version: 1.0
In-Reply-To: <545422A3.5010101@gaast.net>
References: <543F049F.5090605@gaast.net>
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
	<CAE9FiQVQK4aa9bW3d3=rw+hgogSFuKnwFSutSqcMrmCCc9_3dw@mail.gmail.com>
	<545422A3.5010101@gaast.net>
Date: Fri, 31 Oct 2014 19:10:29 -0700
X-Google-Sender-Auth: UBocZgEzE8BJjUfMR1WuzXHm--k
Message-ID: <CAE9FiQXFeuQCrc2EAXsVaBGT+TpCpg+0uJsukCTNQTjDG7p5Rw@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e01184afe2486740506c29e85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01184afe2486740506c29e85
Content-Type: text/plain; charset=UTF-8

On Fri, Oct 31, 2014 at 5:00 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Hello,
>
> Patch #1 worked after a simple s/&&/)/. And patch #2 seems to fix the
> problem as well!

updated first #1.

--089e01184afe2486740506c29e85
Content-Type: text/x-patch; charset=US-ASCII; name="pci_enable_bridge_ite_v2.patch"
Content-Disposition: attachment; filename="pci_enable_bridge_ite_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1yc30uf0

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
bWQpOworCQlpZiAoY21kICYgKFBDSV9DT01NQU5EX0lPIHwgUENJX0NPTU1BTkRfTUVNT1JZKSkK
KwkJCXBjaV9lbmFibGVfYnJpZGdlKGRldik7CisJfQorfQorREVDTEFSRV9QQ0lfRklYVVBfRklO
QUwoUENJX1ZFTkRPUl9JRF9JVEUsIDB4ODg5MiwgcGNpX2VuYWJsZV9pdGUpOworCiBzdGF0aWMg
aW50IHBjaV9lbmFibGVfZGV2aWNlX2ZsYWdzKHN0cnVjdCBwY2lfZGV2ICpkZXYsIHVuc2lnbmVk
IGxvbmcgZmxhZ3MpCiB7CiAJc3RydWN0IHBjaV9kZXYgKmJyaWRnZTsK
--089e01184afe2486740506c29e85--
