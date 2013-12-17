Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3LQATS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:19:18 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35662 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3LQATP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:19:15 -0500
MIME-Version: 1.0
Date: Mon, 16 Dec 2013 16:19:14 -0800
Message-ID: <CAMe9rOrcppHvC5g8U9n7D+pxVGdu1G598pge3Erfw7Pr-iEpAQ@mail.gmail.com>
Subject: [PATCH 2/2] Use __kernel_long_t for __statfs_word
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c301fce2194504edafe0d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c301fce2194504edafe0d1
Content-Type: text/plain; charset=ISO-8859-1

X32 statfs system call is the same as x86-64 statfs system call, which
uses 64-bit integer for __statfs_word.  This patch defines __statfs_word
as __kernel_long_t instead of long.


-- 
H.J.

--001a11c301fce2194504edafe0d1
Content-Type: text/plain; charset=US-ASCII; 
	name="0002-Use-__kernel_long_t-for-__statfs_word.patch"
Content-Disposition: attachment; 
	filename="0002-Use-__kernel_long_t-for-__statfs_word.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpaelo690

RnJvbSBmNGI2MDAxNThkOTM2NWZjMmFhZDExZTE0NDY5OWU3ZmZhZWZhZjNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiSC5KLiBMdSIgPGhqbC50b29sc0BnbWFpbC5jb20+CkRhdGU6
IE1vbiwgMTYgRGVjIDIwMTMgMTY6MTI6NTcgLTA4MDAKU3ViamVjdDogW1BBVENIIDIvMl0gVXNl
IF9fa2VybmVsX2xvbmdfdCBmb3IgX19zdGF0ZnNfd29yZAoKWDMyIHN0YXRmcyBzeXN0ZW0gY2Fs
bCBpcyB0aGUgc2FtZSBhcyB4ODYtNjQgc3RhdGZzIHN5c3RlbSBjYWxsLCB3aGljaAp1c2VzIDY0
LWJpdCBpbnRlZ2VyIGZvciBfX3N0YXRmc193b3JkLiAgVGhpcyBwYXRjaCBkZWZpbmVzIF9fc3Rh
dGZzX3dvcmQKYXMgX19rZXJuZWxfbG9uZ190IGluc3RlYWQgb2YgbG9uZy4KCkguSi4KLS0tClNp
Z25lZC1vZmYtYnk6IEguSi4gTHUgPGhqbC50b29sc0BnbWFpbC5jb20+Ci0tLQogaW5jbHVkZS91
YXBpL2FzbS1nZW5lcmljL3N0YXRmcy5oIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2FzbS1nZW5l
cmljL3N0YXRmcy5oIGIvaW5jbHVkZS91YXBpL2FzbS1nZW5lcmljL3N0YXRmcy5oCmluZGV4IDA5
OTk2NDcuLmNiODljYzcgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9hc20tZ2VuZXJpYy9zdGF0
ZnMuaAorKysgYi9pbmNsdWRlL3VhcGkvYXNtLWdlbmVyaWMvc3RhdGZzLmgKQEAgLTEzLDcgKzEz
LDcgQEAKICAqLwogI2lmbmRlZiBfX3N0YXRmc193b3JkCiAjaWYgX19CSVRTX1BFUl9MT05HID09
IDY0Ci0jZGVmaW5lIF9fc3RhdGZzX3dvcmQgbG9uZworI2RlZmluZSBfX3N0YXRmc193b3JkIF9f
a2VybmVsX2xvbmdfdAogI2Vsc2UKICNkZWZpbmUgX19zdGF0ZnNfd29yZCBfX3UzMgogI2VuZGlm
Ci0tIAoxLjguMy4xCgo=
--001a11c301fce2194504edafe0d1--
