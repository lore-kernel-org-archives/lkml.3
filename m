Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3JJPOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:14:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3JJPOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:14:39 -0400
Date: Thu, 10 Oct 2013 20:44:32 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
In-Reply-To: <20131009144849.96389b7cdb3a553e52682137@linux-foundation.org>
Message-ID: <alpine.LFD.2.03.1310102041090.3691@erqung.pbz>
References: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz> <20130923125256.e53b51a137a19a972c6026a2@linux-foundation.org> <alpine.LFD.2.03.1309250035480.5312@erqung.pbz> <20131009144849.96389b7cdb3a553e52682137@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1345281293-1381418077=:3691"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1345281293-1381418077=:3691
Content-Type: TEXT/PLAIN; charset=US-ASCII

   Hello Andrew,
+-- On Wed, 9 Oct 2013, Andrew Morton wrote --+
| It would be better to make the change in one place, rather than for
| each architecture.  That would appear to involve moving a hunk from
| arch/x86/Makefile into init/Makefile, or perhaps ./Makefile.

  Please see this revised version, I missed to include init/do_mounts_rd.c 
changes in the previous one.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
--0-1345281293-1381418077=:3691
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-Export-initial-ramdisk-compression-config-option.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.2.03.1310102044320.3691@erqung.pbz>
Content-Description: 
Content-Disposition: attachment; filename=0001-Export-initial-ramdisk-compression-config-option.patch

RnJvbSAxNGRjY2VlOThmMTJmMmRiY2EyMjQ1MTBiY2ZlZGQxYTM5N2VkMTc3
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogUCBKIFAgPHByYXNh
ZEByZWRoYXQuY29tPg0KRGF0ZTogVGh1LCAxMCBPY3QgMjAxMyAyMDozNzo0
OCArMDUzMA0KU3ViamVjdDogRXhwb3J0IGluaXRpYWwgcmFtZGlzayBjb21w
cmVzc2lvbiBjb25maWcgb3B0aW9uDQoNCk1ha2UgbWVudWNvbmZpZyBhbGxv
d3Mgb25lIHRvIGNob29zZSBjb21wcmVzc2lvbiBmb3JtYXQgb2YgYW4NCmlu
aXRpYWwgcmFtZGlzayBpbWFnZS4gQnV0IHRoaXMgY2hvaWNlIGRvZXMgbm90
IHJlc3VsdCBpbiBkdWx5DQpjb21wcmVzc2VkIHJhbWRpc2sgaW1hZ2UuIEJl
Y2F1c2UgLSAkIG1ha2UgaW5zdGFsbCAtIGRvZXMgbm90DQpwYXNzIG9uIHRo
ZSBzZWxlY3RlZCBjb21wcmVzc2lvbiBjaG9pY2UgdG8gdGhlIGRyYWN1dCg4
KSB0b29sLA0Kd2hpY2ggY3JlYXRlcyB0aGUgaW5pdHJhbWZzIGZpbGUuIGRy
YWN1dCg4KSBnZW5lcmF0ZXMgdGhlIGltYWdlDQp3aXRoIHRoZSBkZWZhdWx0
IGNvbXByZXNzaW9uLCBpZS4gZ3ppcCgxKS4NCg0KVGhpcyBwYXRjaCBleHBv
cnRzIHRoZSBzZWxlY3RlZCBjb21wcmVzc2lvbiBvcHRpb24gdG8gYSBzdWIt
c2hlbGwNCmVudmlyb25tZW50LCBzbyB0aGF0IGl0IGNvdWxkIGJlIHVzZWQg
YnkgZHJhY3V0KDgpIHRvb2wgdG8gZ2VuZXJhdGUNCmFwcHJvcHJpYXRlbHkg
Y29tcHJlc3NlZCBpbml0cmFtZnMgaW1hZ2VzLg0KDQpUaGVyZSBpc24ndCBh
IHN0cmFpZ2h0IGZvcndhcmQgd2F5IHRvIHBhc3Mgb24gb3B0aW9ucyB0byBk
cmFjdXQoOCkNCnZpYSBwb3NpdGlvbmFsIHBhcmFtZXRlcnMuIEJlY2F1c2Ug
aXQgaXMgaW5kaXJlY3RseSBpbnZva2VkIGF0IHRoZQ0KZW5kIG9mIGEgJCBt
YWtlIGluc3RhbGwgc2VxdWVuY2UuDQoNCiAjIG1ha2UgaW5zdGFsbA0KICAg
LT4gYXJjaC8kYXJjaC9ib290L01ha2VmaWxlDQogICAgLT4gYXJjaC8kYXJj
aC9ib290L2luc3RhbGwuc2gNCiAgICAgLT4gL3NiaW5nL2luc3RhbGxrZXJu
ZWwgLi4uDQogICAgICAtPiAvc2Jpbi9uZXcta2VybmVsLXBrZyAuLi4NCiAg
ICAgICAtPiAvc2Jpbi9kcmFjdXQgLi4uDQoNCmRpZmYgLS1naXQgYS9NYWtl
ZmlsZSBiL01ha2VmaWxlDQppbmRleCA4ZDA2NjhmLi41YzdmOGFhIDEwMDY0
NA0KLS0tIGEvTWFrZWZpbGUNCisrKyBiL01ha2VmaWxlDQpAQCAtNzIwLDYg
KzcyMCwyMiBAQCBtb2Rfc3RyaXBfY21kID0gdHJ1ZQ0KIGVuZGlmICMgSU5T
VEFMTF9NT0RfU1RSSVANCiBleHBvcnQgbW9kX3N0cmlwX2NtZA0KIA0KKyMg
U2VsZWN0IGluaXRpYWwgcmFtZGlzayBjb21wcmVzc2lvbiBmb3JtYXQsIGRl
ZmF1bHQgaXMgZ3ppcCgxKS4NCisjIFRoaXMgc2hhbGwgYmUgdXNlZCBieSB0
aGUgZHJhY3V0KDgpIHRvb2wgd2hpbGUgY3JlYXRpbmcgYW4gaW5pdHJhbWZz
IGltYWdlLg0KKyMNCitJTklUUkRfQ09NUFJFU1M9Z3ppcA0KK2lmZXEgKCQo
Q09ORklHX1JEX0JaSVAyKSwgeSkNCisgICAgICAgIElOSVRSRF9DT01QUkVT
Uz1iemlwMg0KK2Vsc2UgaWZlcSAoJChDT05GSUdfUkRfTFpNQSksIHkpDQor
ICAgICAgICBJTklUUkRfQ09NUFJFU1M9bHptYQ0KK2Vsc2UgaWZlcSAoJChD
T05GSUdfUkRfWFopLCB5KQ0KKyAgICAgICAgSU5JVFJEX0NPTVBSRVNTPXh6
DQorZWxzZSBpZmVxICgkKENPTkZJR19SRF9MWk8pLCB5KQ0KKyAgICAgICAg
SU5JVFJEX0NPTVBSRVNTPWx6bw0KK2Vsc2UgaWZlcSAoJChDT05GSUdfUkRf
TFo0KSwgeSkNCisgICAgICAgIElOSVRSRF9DT01QUkVTUz1sejQNCitlbmRp
Zg0KK2V4cG9ydCBJTklUUkRfQ09NUFJFU1MNCiANCiBpZmRlZiBDT05GSUdf
TU9EVUxFX1NJR19BTEwNCiBNT0RTRUNLRVkgPSAuL3NpZ25pbmdfa2V5LnBy
aXYNCmRpZmYgLS1naXQgYS9pbml0L2RvX21vdW50c19yZC5jIGIvaW5pdC9k
b19tb3VudHNfcmQuYw0KaW5kZXggYmRhYTM0NS4uOWVlMzQyNyAxMDA2NDQN
Ci0tLSBhL2luaXQvZG9fbW91bnRzX3JkLmMNCisrKyBiL2luaXQvZG9fbW91
bnRzX3JkLmMNCkBAIC01Nyw2ICs1NywxMSBAQCBzdGF0aWMgaW50IF9faW5p
dCBjcmRfbG9hZChpbnQgaW5fZmQsIGludCBvdXRfZmQsIGRlY29tcHJlc3Nf
Zm4gZGVjbyk7DQogICoJY3JhbWZzDQogICoJc3F1YXNoZnMNCiAgKglnemlw
DQorICoJYnppcDINCisgKglsem1hDQorICoJeHoNCisgKglsem8NCisgKgls
ejQNCiAgKi8NCiBzdGF0aWMgaW50IF9faW5pdA0KIGlkZW50aWZ5X3JhbWRp
c2tfaW1hZ2UoaW50IGZkLCBpbnQgc3RhcnRfYmxvY2ssIGRlY29tcHJlc3Nf
Zm4gKmRlY29tcHJlc3NvcikNCi0tIA0KMS44LjMuMQ0KDQo=

--0-1345281293-1381418077=:3691--
