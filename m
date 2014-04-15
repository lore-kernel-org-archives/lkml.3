Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaDOU1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:27:16 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54971 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOU1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:27:15 -0400
Message-ID: <534D962B.9010304@cit-ec.uni-bielefeld.de>
Date: Tue, 15 Apr 2014 22:27:23 +0200
From: Robert ABEL <rabel@cit-ec.uni-bielefeld.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] SYSFS: fix attribute_group bin file path on removal
Content-Type: multipart/mixed;
 boundary="------------040209060505090507070500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040209060505090507070500
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Cody Schafer already fixed binary file creation for attribute groups, 
see [1].
This patch makes the appropriate changes for binary file removal
of attribute groups.
[1]: http://lkml.org/lkml/2014/2/27/832

Signed-off-by: Robert ABEL <rabel@cit-ec.uni-bielefeld.de>

--------------040209060505090507070500
Content-Type: text/plain; charset=windows-1252;
 name="0001-SYSFS-fix-attribute_group-bin-file-path-on-removal.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-SYSFS-fix-attribute_group-bin-file-path-on-removal.patc";
 filename*1="h"

RnJvbSA3MDZhNjUyZDM2NTM0NzBhNWNhYWU1ODlmNjk0NTQ5ODAyNmM5NGMxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBSb2JlcnQgQUJFTCA8cmFiZWxAY2l0LWVjLnVuaS1i
aWVsZWZlbGQuZGU+CkRhdGU6IFR1ZSwgMTUgQXByIDIwMTQgMjI6MDE6MzUgKzAyMDAKU3Vi
amVjdDogW1BBVENIXSBTWVNGUzogZml4IGF0dHJpYnV0ZV9ncm91cCBiaW4gZmlsZSBwYXRo
IG9uIHJlbW92YWwKCkNvZHkgU2NoYWZlciBhbHJlYWR5IGZpeGVkIGJpbmFyeSBmaWxlIGNy
ZWF0aW9uIGZvciBhdHRyaWJ1dGUgZ3JvdXBzLCBzZWUgWzFdLgpUaGlzIHBhdGNoIG1ha2Vz
IHRoZSBhcHByb3ByaWF0ZSBjaGFuZ2VzIGZvciBiaW5hcnkgZmlsZSByZW1vdmFsCm9mIGF0
dHJpYnV0ZSBncm91cHMuClsxXTogaHR0cDovL2xrbWwub3JnL2xrbWwvMjAxNC8yLzI3Lzgz
MgoKU2lnbmVkLW9mZi1ieTogUm9iZXJ0IEFCRUwgPHJhYmVsQGNpdC1lYy51bmktYmllbGVm
ZWxkLmRlPgotLS0KIGZzL3N5c2ZzL2dyb3VwLmMgfCAgIDEwICsrKysrLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvc3lzZnMvZ3JvdXAuYyBiL2ZzL3N5c2ZzL2dyb3VwLmMKaW5kZXggYWEwNDA2OC4u
N2QyYTg2MCAxMDA2NDQKLS0tIGEvZnMvc3lzZnMvZ3JvdXAuYworKysgYi9mcy9zeXNmcy9n
cm91cC5jCkBAIC0xOCw3ICsxOCw3IEBACiAjaW5jbHVkZSAic3lzZnMuaCIKIAogCi1zdGF0
aWMgdm9pZCByZW1vdmVfZmlsZXMoc3RydWN0IGtlcm5mc19ub2RlICpwYXJlbnQsIHN0cnVj
dCBrb2JqZWN0ICprb2JqLAorc3RhdGljIHZvaWQgcmVtb3ZlX2ZpbGVzKHN0cnVjdCBrZXJu
ZnNfbm9kZSAqcGFyZW50LAogCQkJIGNvbnN0IHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgKmdy
cCkKIHsKIAlzdHJ1Y3QgYXR0cmlidXRlICpjb25zdCAqYXR0cjsKQEAgLTI5LDcgKzI5LDcg
QEAgc3RhdGljIHZvaWQgcmVtb3ZlX2ZpbGVzKHN0cnVjdCBrZXJuZnNfbm9kZSAqcGFyZW50
LCBzdHJ1Y3Qga29iamVjdCAqa29iaiwKIAkJCWtlcm5mc19yZW1vdmVfYnlfbmFtZShwYXJl
bnQsICgqYXR0ciktPm5hbWUpOwogCWlmIChncnAtPmJpbl9hdHRycykKIAkJZm9yIChiaW5f
YXR0ciA9IGdycC0+YmluX2F0dHJzOyAqYmluX2F0dHI7IGJpbl9hdHRyKyspCi0JCQlzeXNm
c19yZW1vdmVfYmluX2ZpbGUoa29iaiwgKmJpbl9hdHRyKTsKKwkJCWtlcm5mc19yZW1vdmVf
YnlfbmFtZShwYXJlbnQsICgqYmluX2F0dHIpLT5hdHRyLm5hbWUpOwogfQogCiBzdGF0aWMg
aW50IGNyZWF0ZV9maWxlcyhzdHJ1Y3Qga2VybmZzX25vZGUgKnBhcmVudCwgc3RydWN0IGtv
YmplY3QgKmtvYmosCkBAIC02Miw3ICs2Miw3IEBAIHN0YXRpYyBpbnQgY3JlYXRlX2ZpbGVz
KHN0cnVjdCBrZXJuZnNfbm9kZSAqcGFyZW50LCBzdHJ1Y3Qga29iamVjdCAqa29iaiwKIAkJ
CQlicmVhazsKIAkJfQogCQlpZiAoZXJyb3IpIHsKLQkJCXJlbW92ZV9maWxlcyhwYXJlbnQs
IGtvYmosIGdycCk7CisJCQlyZW1vdmVfZmlsZXMocGFyZW50LCBncnApOwogCQkJZ290byBl
eGl0OwogCQl9CiAJfQpAQCAtNzksNyArNzksNyBAQCBzdGF0aWMgaW50IGNyZWF0ZV9maWxl
cyhzdHJ1Y3Qga2VybmZzX25vZGUgKnBhcmVudCwgc3RydWN0IGtvYmplY3QgKmtvYmosCiAJ
CQkJYnJlYWs7CiAJCX0KIAkJaWYgKGVycm9yKQotCQkJcmVtb3ZlX2ZpbGVzKHBhcmVudCwg
a29iaiwgZ3JwKTsKKwkJCXJlbW92ZV9maWxlcyhwYXJlbnQsIGdycCk7CiAJfQogZXhpdDoK
IAlyZXR1cm4gZXJyb3I7CkBAIC0yMjQsNyArMjI0LDcgQEAgdm9pZCBzeXNmc19yZW1vdmVf
Z3JvdXAoc3RydWN0IGtvYmplY3QgKmtvYmosCiAJCWtlcm5mc19nZXQoa24pOwogCX0KIAot
CXJlbW92ZV9maWxlcyhrbiwga29iaiwgZ3JwKTsKKwlyZW1vdmVfZmlsZXMoa24sIGdycCk7
CiAJaWYgKGdycC0+bmFtZSkKIAkJa2VybmZzX3JlbW92ZShrbik7CiAKLS0gCjEuNy45LjUK
Cg==
--------------040209060505090507070500--
