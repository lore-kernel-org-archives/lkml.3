Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3CZVPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:15:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53547 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab3CZVP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:15:27 -0400
Message-Id: <1364332526.8559.140661209554365.0203B0A4@webmail.messagingengine.com>
X-Sasl-Enc: WAzNYtncXUKe8boQxb1/AedQB+/+nGxgqhv1pK5i3ogQ 1364332526
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Hans de Bruin <jmdebruin@xmsnet.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: "intel-gfx" <intel-gfx@lists.freedesktop.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_136433252685590";
 charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - html
In-Reply-To: <514F6DF9.1070602@xmsnet.nl>
References: <514F6DF9.1070602@xmsnet.nl>
Subject: Re: regression: grass turns red
Date: Tue, 26 Mar 2013 22:15:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--_----------=_136433252685590
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Hi Hans,

Could you check if the attached patch solves your problem?

Greetings,
    Alexander van Heukelum

On Sun, Mar 24, 2013, at 22:19, Hans de Bruin wrote:
> commit 49cb25e9290 x86: 'get rid of pt_regs argument in vm86/vm86old' 
> somehow breaks the colors when I play 'civilization I' under xdosemu. 
> During the intro of the game something the colors get messed up. When 
> the game begins the grass of the earth is red. Reverting the  commit 
> fixes the problem.
> 
> -- 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

--_----------=_136433252685590
Content-Disposition: attachment; filename="0001-x86-vm86-fix-VM86-syscalls-use-asmlinkage-calling-co.patch"
Content-Id: <1364332346.8284.dfdcb9444409241bacceadb1de53cd948b6ff520.755865BF@messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-x86-vm86-fix-VM86-syscalls-use-asmlinkage-calling-co.patch"

RnJvbSAyYjA5ZjM3ZmQ5ZGVmYzAyYzZkYTk5MDBlMjM0MThhNDAxZDdhMmI5
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4YW5kZXIgdmFu
IEhldWtlbHVtIDxoZXVrZWx1bUBmYXN0bWFpbC5mbT4KRGF0ZTogVHVlLCAy
NiBNYXIgMjAxMyAyMTo1Nzo0MyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHg4
Niwgdm04NjogZml4IFZNODYgc3lzY2FsbHM6IHVzZSBhc21saW5rYWdlIGNh
bGxpbmcgY29udmVudGlvbgoKVGhpcyBtaWdodCBzb2x2ZSB0aGUgaXNzdWUg
b2YgdGhlIHJlZCBncmFzcyBpbiAnY2l2aWxpemF0aW9uIEknIHVuZGVyIHhk
b3NlbXUuIENvbW1pdAo0OWNiMjVlOTI5MCB4ODY6ICdnZXQgcmlkIG9mIHB0
X3JlZ3MgYXJndW1lbnQgaW4gdm04Ni92bTg2b2xkJyBnb3QgcmlkIG9mIHRo
ZSBwdF9yZWdzCnN0dWIgZm9yIHN5c192bTg2b2xkIGFuZCBzeXNfdm04Ni4g
VGhlIGZ1bmN0aW9ucyB3ZXJlLCBob3dldmVyLCBub3QgY2hhbmdlZCB0byB1
c2UgdGhlCmFzbWxpbmthZ2UgY2FsbGluZyBjb252ZW50aW9uLgoKU2lnbmVk
LW9mZi1ieTogQWxleGFuZGVyIHZhbiBIZXVrZWx1bSA8aGV1a2VsdW1AZmFz
dG1haWwuZm0+Ci0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20vc3lzY2FsbHMu
aCB8IDQgKystLQogYXJjaC94ODYva2VybmVsL3ZtODZfMzIuYyAgICAgICB8
IDYgKysrKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwg
NCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9zeXNjYWxscy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc3lzY2Fs
bHMuaAppbmRleCA2Y2YwYTljLi5hMjQ1Yjg4IDEwMDY0NAotLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxscy5oCisrKyBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3N5c2NhbGxzLmgKQEAgLTM3LDggKzM3LDggQEAgYXNtbGlu
a2FnZSBpbnQgc3lzX2dldF90aHJlYWRfYXJlYShzdHJ1Y3QgdXNlcl9kZXNj
IF9fdXNlciAqKTsKIHVuc2lnbmVkIGxvbmcgc3lzX3NpZ3JldHVybih2b2lk
KTsKIAogLyoga2VybmVsL3ZtODZfMzIuYyAqLwotaW50IHN5c192bTg2b2xk
KHN0cnVjdCB2bTg2X3N0cnVjdCBfX3VzZXIgKik7Ci1pbnQgc3lzX3ZtODYo
dW5zaWduZWQgbG9uZywgdW5zaWduZWQgbG9uZyk7Cithc21saW5rYWdlIGlu
dCBzeXNfdm04Nm9sZChzdHJ1Y3Qgdm04Nl9zdHJ1Y3QgX191c2VyICopOwor
YXNtbGlua2FnZSBpbnQgc3lzX3ZtODYodW5zaWduZWQgbG9uZywgdW5zaWdu
ZWQgbG9uZyk7CiAKICNlbHNlIC8qIENPTkZJR19YODZfMzIgKi8KIApkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3ZtODZfMzIuYyBiL2FyY2gveDg2
L2tlcm5lbC92bTg2XzMyLmMKaW5kZXggMWNmNTc2Ni4uN2Y3MjgwNyAxMDA2
NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL3ZtODZfMzIuYworKysgYi9hcmNo
L3g4Ni9rZXJuZWwvdm04Nl8zMi5jCkBAIC0yMDIsNyArMjAyLDcgQEAgb3V0
Ogogc3RhdGljIGludCBkb192bTg2X2lycV9oYW5kbGluZyhpbnQgc3ViZnVu
Y3Rpb24sIGludCBpcnFudW1iZXIpOwogc3RhdGljIHZvaWQgZG9fc3lzX3Zt
ODYoc3RydWN0IGtlcm5lbF92bTg2X3N0cnVjdCAqaW5mbywgc3RydWN0IHRh
c2tfc3RydWN0ICp0c2spOwogCi1pbnQgc3lzX3ZtODZvbGQoc3RydWN0IHZt
ODZfc3RydWN0IF9fdXNlciAqdjg2KQorYXNtbGlua2FnZSBpbnQgc3lzX3Zt
ODZvbGQoc3RydWN0IHZtODZfc3RydWN0IF9fdXNlciAqdjg2KQogewogCXN0
cnVjdCBrZXJuZWxfdm04Nl9zdHJ1Y3QgaW5mbzsgLyogZGVjbGFyZSB0aGlz
IF9vbiB0b3BfLAogCQkJCQkgKiB0aGlzIGF2b2lkcyB3YXN0aW5nIG9mIHN0
YWNrIHNwYWNlLgpAQCAtMjI3LDExICsyMjcsMTIgQEAgaW50IHN5c192bTg2
b2xkKHN0cnVjdCB2bTg2X3N0cnVjdCBfX3VzZXIgKnY4NikKIAlkb19zeXNf
dm04NigmaW5mbywgdHNrKTsKIAlyZXQgPSAwOwkvKiB3ZSBuZXZlciByZXR1
cm4gaGVyZSAqLwogb3V0OgorCWFzbWxpbmthZ2VfcHJvdGVjdCgxLCByZXQs
IHY4Nik7CiAJcmV0dXJuIHJldDsKIH0KIAogCi1pbnQgc3lzX3ZtODYodW5z
aWduZWQgbG9uZyBjbWQsIHVuc2lnbmVkIGxvbmcgYXJnKQorYXNtbGlua2Fn
ZSBpbnQgc3lzX3ZtODYodW5zaWduZWQgbG9uZyBjbWQsIHVuc2lnbmVkIGxv
bmcgYXJnKQogewogCXN0cnVjdCBrZXJuZWxfdm04Nl9zdHJ1Y3QgaW5mbzsg
LyogZGVjbGFyZSB0aGlzIF9vbiB0b3BfLAogCQkJCQkgKiB0aGlzIGF2b2lk
cyB3YXN0aW5nIG9mIHN0YWNrIHNwYWNlLgpAQCAtMjc4LDYgKzI3OSw3IEBA
IGludCBzeXNfdm04Nih1bnNpZ25lZCBsb25nIGNtZCwgdW5zaWduZWQgbG9u
ZyBhcmcpCiAJZG9fc3lzX3ZtODYoJmluZm8sIHRzayk7CiAJcmV0ID0gMDsJ
Lyogd2UgbmV2ZXIgcmV0dXJuIGhlcmUgKi8KIG91dDoKKwlhc21saW5rYWdl
X3Byb3RlY3QoMiwgcmV0LCBjbWQsIGFyZyk7CiAJcmV0dXJuIHJldDsKIH0K
IAotLSAKMS44LjEuMgoK

--_----------=_136433252685590--

