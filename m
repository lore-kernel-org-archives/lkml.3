Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaJ1EDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:03:15 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35918 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaJ1EDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
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
Date: Mon, 27 Oct 2014 21:03:11 -0700
X-Google-Sender-Auth: 1OgVQo3CFQAyigfsIDwiepXC0vQ
Message-ID: <CAE9FiQWi_fRssxm_0i9wK79diKY_YYThmgQx7ZgmY7YWf6s=Qw@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a113ff7a4c704d3050673b995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a113ff7a4c704d3050673b995
Content-Type: text/plain; charset=UTF-8

On Mon, Oct 27, 2014 at 6:12 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Oct 27, 2014 at 5:03 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
>> I was curious about that already, did that with a 3.16.6 that I think just
>> had your revert applied (and using lspci -xxxx to get the dump which I
>> assumed would be the same): No changes to 04:00 at all.
>>
>> Confirmed that this is the case with 3.17 + those patches as well, it's
>> showing this at all times:
>
> can you post
> lspci -vvxxxx -s 00:1c.3
> lspci -vvxxxx -s 04:00.0
> before reverting enable bridge early patch
> and after reverting on 3.17+?

Please check if attached patch could fix the problem on your setup.

Thanks

Yinghai

--001a113ff7a4c704d3050673b995
Content-Type: text/x-patch; charset=US-ASCII; name="pci_set_bridge_d0.patch"
Content-Disposition: attachment; filename="pci_set_bridge_d0.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1sqc3560

LS0tCiBkcml2ZXJzL3BjaS9xdWlya3MuYyB8ICAgIDYgKysrKysrCiAxIGZpbGUgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3F1aXJrcy5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3F1aXJrcy5jCisrKyBsaW51
eC0yLjYvZHJpdmVycy9wY2kvcXVpcmtzLmMKQEAgLTMwOTgsNiArMzA5OCwxMiBAQCBERUNMQVJF
X1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0lOCiBERUNMQVJFX1BDSV9GSVhVUF9GSU5B
TChQQ0lfVkVORE9SX0lEX0lOVEVMLCAweDhjMDIsIHF1aXJrX3JlbW92ZV9kM19kZWxheSk7CiBE
RUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0lOVEVMLCAweDhjMjIsIHF1aXJr
X3JlbW92ZV9kM19kZWxheSk7CiAKK3N0YXRpYyB2b2lkIGVuYWJsZV9wY2lfYnJpZGdlX2QwKHN0
cnVjdCBwY2lfZGV2ICpkZXYpCit7CisJcGNpX3NldF9wb3dlcl9zdGF0ZShkZXYsIFBDSV9EMCk7
Cit9CitERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0lURSwgMHg4ODkyLCBl
bmFibGVfcGNpX2JyaWRnZV9kMCk7CisKIC8qCiAgKiBTb21lIGRldmljZXMgbWF5IHBhc3Mgb3Vy
IGNoZWNrIGluIHBjaV9pbnR4X21hc2tfc3VwcG9ydGVkIGlmCiAgKiBQQ0lfQ09NTUFORF9JTlRY
X0RJU0FCTEUgd29ya3MgdGhvdWdoIHRoZXkgYWN0dWFsbHkgZG8gbm90IHByb3Blcmx5Cg==
--001a113ff7a4c704d3050673b995--
