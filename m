Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaJaQLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:11:51 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47133 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaJaQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <545358D5.6070903@gaast.net>
References: <543F049F.5090605@gaast.net>
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
	<CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com>
	<5452C8BE.3060206@gaast.net>
	<CAE9FiQWd7wC9ijzgObCcGd9QE+U3_wzjQwafXhV=U61hLxGszg@mail.gmail.com>
	<CAE9FiQXPZdYndp6rTKxLUkkwX=AQtRVH3JJC=xzQfsehtBgOqA@mail.gmail.com>
	<545358D5.6070903@gaast.net>
Date: Fri, 31 Oct 2014 09:11:48 -0700
X-Google-Sender-Auth: Cfe1nObRPtepWM9fIM48EkMjhqI
Message-ID: <CAE9FiQWeZ4AXwwT=NS96Q+FxPz+3Bj5rf8JoRDmJ-RHBhjj78g@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0149d116144b8b0506ba41eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149d116144b8b0506ba41eb
Content-Type: text/plain; charset=UTF-8

On Fri, Oct 31, 2014 at 2:39 AM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Hello Yinghai,
>
> On 31-10-14 02:13, Yinghai Lu wrote:
>>
>> Last try:
>>
>> Please check attached patch that will keep state consistent.
>
>
> Good news: This last patch worked! For good measure, I ran my test twice
> with a reboot in between. Worked consistently.
>
> And similarly, to ensure that your debugging-at-boottime-only patch wasn't
> just working by accident yesterday, I tested it twice more with the same
> effect.

Good. Please check if attached one on top of 3.17 only would work too.

Thanks

Yinghai

--089e0149d116144b8b0506ba41eb
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_xxx1.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_xxx1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1xq1p6l0

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgIDQgKysrLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9w
Y2kuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9wY2kuYworKysg
bGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS5jCkBAIC0xMDYzLDcgKzEwNjMsOSBAQCBzdGF0aWMg
dm9pZCBwY2lfcmVzdG9yZV9jb25maWdfc3BhY2Uoc3RyCiAJCXBjaV9yZXN0b3JlX2NvbmZpZ19z
cGFjZV9yYW5nZShwZGV2LCA0LCA5LCAxMCk7CiAJCXBjaV9yZXN0b3JlX2NvbmZpZ19zcGFjZV9y
YW5nZShwZGV2LCAwLCAzLCAwKTsKIAl9IGVsc2UgewotCQlwY2lfcmVzdG9yZV9jb25maWdfc3Bh
Y2VfcmFuZ2UocGRldiwgMCwgMTUsIDApOworCQkvKiBSZXN0b3JlIEJBUnMgYmVmb3JlIHRoZSBj
b21tYW5kIHJlZ2lzdGVyLiAqLworCQlwY2lfcmVzdG9yZV9jb25maWdfc3BhY2VfcmFuZ2UocGRl
diwgNCwgMTUsIDApOworCQlwY2lfcmVzdG9yZV9jb25maWdfc3BhY2VfcmFuZ2UocGRldiwgMCwg
MywgMCk7CiAJfQogfQogCg==
--089e0149d116144b8b0506ba41eb--
