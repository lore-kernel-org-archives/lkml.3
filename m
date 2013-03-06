Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3CFWp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:45:59 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.90]:49486 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567Ab3CFWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:45:57 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: hv_netvsc: WARNING in softirq.c
Thread-Topic: hv_netvsc: WARNING in softirq.c
Thread-Index: AQHOFY6mlTKiRrtVMEyJsd7vlhJcdZiPmH8QgAFzAwCACDndgA==
Date: Wed, 6 Mar 2013 22:45:11 +0000
Message-ID: <4147bb5a7cf547c19c6a5a6b459a957d@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20130228083437.GA28143@lnx-rg>
 <78fd1c1df13b449887de6e0b3505a988@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <CACQ1gAgyYp+Dxmk-0C3zfKK+CkEwQX51NvWjzkV7=8GC3CD=Qg@mail.gmail.com>
In-Reply-To: <CACQ1gAgyYp+Dxmk-0C3zfKK+CkEwQX51NvWjzkV7=8GC3CD=Qg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: multipart/mixed;
	boundary="_002_4147bb5a7cf547c19c6a5a6b459a957dDFMDB3MBX1506exchangeco_"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(47446002)(80022001)(77982001)(59766001)(512874001)(562884003)(76482001)(20776003)(51856001)(16406001)(74662001)(31966008)(44976002)(79102001)(56816002)(56776001)(33646001)(66066001)(47976001)(50986001)(4396001)(74502001)(876001)(65816001)(69226001)(46102001)(47736001)(53806001)(49866001)(54316002)(63696002)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUSR01MB603;H:hybrid.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 07778E4001
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_4147bb5a7cf547c19c6a5a6b459a957dDFMDB3MBX1506exchangeco_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmljaGFyZCBHZW5vdWQg
W21haWx0bzpyaWNoYXJkLmdlbm91ZEBnbWFpbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgTWFyY2gg
MDEsIDIwMTMgMzozOSBBTQ0KPiBUbzogSGFpeWFuZyBaaGFuZw0KPiBDYzogS1kgU3Jpbml2YXNh
bjsgZGV2ZWxAbGludXhkcml2ZXJwcm9qZWN0Lm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsN
Cj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogaHZfbmV0dnNj
OiBXQVJOSU5HIGluIHNvZnRpcnEuYw0KPiANCj4gMjAxMy8yLzI4IEhhaXlhbmcgWmhhbmcgPGhh
aXlhbmd6QG1pY3Jvc29mdC5jb20+Og0KPiA+IFdlIHdpbGwgbG9vayBpbnRvIHRoaXMuIEFuZCBm
dXJ0aGVyIGluZm8gYXJvdW5kIHRoZSB0aW1lIHdpbGwgYWxzbyBiZQ0KPiBoZWxwZnVsLg0KPiA+
DQo+ID4gVGhhbmtzLA0KPiA+IC0gSGFpeWFuZw0KPiANCj4gVGhlIG9ubHkgdGhpbmcgdGhlIGFk
bWluIHN5cyBjb3VsZCB0aGluayBhYm91dCBpcyBhIHJzeW5jIHByb2Nlc3MNCj4gYmV0d2VlbiB0
aGUgd2luZG93cyBob3N0IGFuZCBBTk9USEVSIGxpbnV4IGd1ZXN0IHRoYXQgZW5kcyBhdCAyMmgz
MA0KPiBtb3JlIG9yIGxlc3MuDQo+ICh0aGUgb3RoZXIgbGludXggZ3Vlc3QgaXMgYSBkZWJpYW4g
Niwgd2l0aG91dCBhbnkgSFYgZHJpdmVyKQ0KDQpJIGhhdmUgZm91bmQgYSBzaW1wbGUgd2F5IHRv
IHJlcHJvZHVjZSB0aGlzIGtpbmQgb2Ygd2FybmluZzoNCjEpIHJlYm9vdCB0aGUgVk0gKGJlY2F1
c2UgdGhpcyB3YXJuaW5nIGNhbiBiZSBkaXNwbGF5ZWQgb25seSBvbmNlLikNCjIpIGxvZ2luIHRv
IHRoZSBob3N0IGFuZCBvcGVuIHRoZSBWTSBbU2V0dGluZ3NdDQozKSBUZW1wb3JhcmlseSBjaGFu
Z2UgdGhlIE5ldHdvcmsgYWRhcHRlcidzIG9wdGlvbiBbVmlydHVhbCBTd2l0Y2hdIHRvICJOb3Qg
Y29ubmVjdGVkIi4NCjQpIHJ1biBkbWVzZywgeW91IHNob3VsZCBzZWUgdGhlIHdhcm5pbmcuDQoN
ClRoZSByZWFzb24gZm9yIHRoZSB3YXJuaW5nIGlzIC0tIG5ldGlmX3R4X2Rpc2FibGUoKSBpcyBj
YWxsZWQgd2hlbiB0aGUgTklDDQppcyBkaXNjb25uZWN0ZWQuIEFuZCBpdCdzIGNhbGxlZCB3aXRo
aW4gaXJxIGNvbnRleHQuIG5ldGlmX3R4X2Rpc2FibGUoKQ0KY2FsbHMgbG9jYWxfYmhfZW5hYmxl
KCkgd2hpY2ggZGlzcGxheXMgd2FybmluZyBpZiBpbiBpcnEuDQoNClRoZSBmaXggaXMgdG8gcmVt
b3ZlIHRoZSB1bm5lY2Vzc2FyeSBuZXRpZl90eF9kaXNhYmxlKCkgaW4gdGhlIG5ldHZzY19saW5r
c3RhdHVzX2NhbGxiYWNrKCkuDQpJIGF0dGFjaGVkIGEgcGF0Y2guIFdvdWxkIHlvdSBsaWtlIHRv
IHRlc3QgaXQgb24geW91ciBzaWRlIGFzIHdlbGw/DQoNClRoYW5rcywNCi0gSGFpeWFuZw0KDQo=

--_002_4147bb5a7cf547c19c6a5a6b459a957dDFMDB3MBX1506exchangeco_
Content-Type: application/octet-stream; name="net_stat_warn_test.patch"
Content-Description: net_stat_warn_test.patch
Content-Disposition: attachment; filename="net_stat_warn_test.patch";
	size=562; creation-date="Wed, 06 Mar 2013 22:31:09 GMT";
	modification-date="Wed, 06 Mar 2013 22:57:28 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2h5cGVydi9uZXR2c2NfZHJ2LmMgYi9kcml2ZXJzL25l
dC9oeXBlcnYvbmV0dnNjX2Rydi5jCmluZGV4IDVmODUyMDUuLjgzNDFiNjIgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L2h5cGVydi9uZXR2c2NfZHJ2LmMKKysrIGIvZHJpdmVycy9uZXQvaHlwZXJ2
L25ldHZzY19kcnYuYwpAQCAtMjQxLDEzICsyNDEsMTEgQEAgdm9pZCBuZXR2c2NfbGlua3N0YXR1
c19jYWxsYmFjayhzdHJ1Y3QgaHZfZGV2aWNlICpkZXZpY2Vfb2JqLAogCiAJaWYgKHN0YXR1cyA9
PSAxKSB7CiAJCW5ldGlmX2NhcnJpZXJfb24obmV0KTsKLQkJbmV0aWZfd2FrZV9xdWV1ZShuZXQp
OwogCQluZGV2X2N0eCA9IG5ldGRldl9wcml2KG5ldCk7CiAJCXNjaGVkdWxlX2RlbGF5ZWRfd29y
aygmbmRldl9jdHgtPmR3b3JrLCAwKTsKIAkJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZuZGV2X2N0
eC0+ZHdvcmssIG1zZWNzX3RvX2ppZmZpZXMoMjApKTsKIAl9IGVsc2UgewogCQluZXRpZl9jYXJy
aWVyX29mZihuZXQpOwotCQluZXRpZl90eF9kaXNhYmxlKG5ldCk7CiAJfQogfQogCg==

--_002_4147bb5a7cf547c19c6a5a6b459a957dDFMDB3MBX1506exchangeco_--
