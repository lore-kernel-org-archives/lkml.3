Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3HWXUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:20:12 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1935 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab3HWXUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:20:05 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Graham Williams" <gwilli@broadcom.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "balbi@ti.com" <balbi@ti.com>
Subject: [PATCH] usb: acm gadget: Null termintate strings table
Thread-Topic: [PATCH] usb: acm gadget: Null termintate strings table
Thread-Index: Ac6gKUihEwnOQOzhRHCsjyOVBTkXDQALCICw
Date: Fri, 23 Aug 2013 23:19:55 +0000
Message-ID: <063828A851006E448B735F1021E028962ACE7736@SJEXCHMB09.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E0932B831W87456869-01-01
Content-Type: multipart/mixed;
 boundary=_002_063828A851006E448B735F1021E028962ACE7736SJEXCHMB09corpa_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--_002_063828A851006E448B735F1021E028962ACE7736SJEXCHMB09corpa_
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

I couldn't get the whitespace formatting correctly from Windows Office (wor=
k email) so I attached the patch file.  I ran it on it applies correctly.

--_002_063828A851006E448B735F1021E028962ACE7736SJEXCHMB09corpa_
Content-Type: application/octet-stream;
 name=0001-usb-acm-gadget-Null-termintate-strings-table.patch
Content-Description: 0001-usb-acm-gadget-Null-termintate-strings-table.patch
Content-Disposition: attachment;
 filename=0001-usb-acm-gadget-Null-termintate-strings-table.patch;
 size=944;
 creation-date="Fri, 23 Aug 2013 23:16:50 GMT";
 modification-date="Fri, 23 Aug 2013 23:16:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmNmZjYWJhODk0NDg5N2QxMjc1ZjJkNjNmMzk3M2M2MjViZWNlYTJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHcmFoYW0gV2lsbGlhbXMgPGd3aWxsaUBicm9hZGNvbS5jb20+
CkRhdGU6IE1vbiwgMTkgQXVnIDIwMTMgMTQ6MDA6MTcgLTA3MDAKU3ViamVjdDogW1BBVENIXSB1
c2I6IGFjbSBnYWRnZXQ6IE51bGwgdGVybWludGF0ZSBzdHJpbmdzIHRhYmxlCgpUaGUgZ2FkZ2V0
IHN0cmluZ3MgdGFibGUgc2hvdWxkIGJlIG51bGwgdGVybWluYXRlZC4KdXNiX2dhZGdldF9nZXRf
c3RyaW5nKCkgbG9vcHMgdGhyb3VnaCB0aGUgdGFibGUKZXhwZWN0aW5nIGEgbnVsbCBhdCB0aGUg
ZW5kIG9mIHRoZSBsaXN0LgoKU2lnbmVkLW9mZi1ieTogR3JhaGFtIFdpbGxpYW1zIDxnd2lsbGlA
YnJvYWRjb20uY29tPgotLS0KIGRyaXZlcnMvdXNiL2dhZGdldC9mX2FjbS5jIHwgMSArCiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRn
ZXQvZl9hY20uYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mX2FjbS5jCmluZGV4IDRiN2UzM2UuLmFi
MTA2NWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL2dhZGdldC9mX2FjbS5jCisrKyBiL2RyaXZl
cnMvdXNiL2dhZGdldC9mX2FjbS5jCkBAIC0yODUsNiArMjg1LDcgQEAgc3RhdGljIHN0cnVjdCB1
c2Jfc3RyaW5nIGFjbV9zdHJpbmdfZGVmc1tdID0gewogCVtBQ01fQ1RSTF9JRFhdLnMgPSAiQ0RD
IEFic3RyYWN0IENvbnRyb2wgTW9kZWwgKEFDTSkiLAogCVtBQ01fREFUQV9JRFhdLnMgPSAiQ0RD
IEFDTSBEYXRhIiwKIAlbQUNNX0lBRF9JRFggXS5zID0gIkNEQyBTZXJpYWwiLAorCXsgIH0gLyog
ZW5kIG9mIGxpc3QgKi8KIH07CiAKIHN0YXRpYyBzdHJ1Y3QgdXNiX2dhZGdldF9zdHJpbmdzIGFj
bV9zdHJpbmdfdGFibGUgPSB7Ci0tIAoxLjguMC4xCgo=

--_002_063828A851006E448B735F1021E028962ACE7736SJEXCHMB09corpa_--

