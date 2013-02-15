Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab3BOSuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:50:54 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:58110 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3BOSuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:50:52 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com> <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
 <20130215174435.GA2792@linux.vnet.ibm.com> <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
 <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Feb 2013 10:50:31 -0800
X-Google-Sender-Auth: j2WVugQhnp6CrD9oFbJhcoZz8gk
Message-ID: <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: multipart/mixed; boundary=14dae9ccd516bb7bb804d5c7dabe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9ccd516bb7bb804d5c7dabe
Content-Type: text/plain; charset=UTF-8

On Fri, Feb 15, 2013 at 10:35 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Feb 15, 2013 at 10:34 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Something like this ENTIRELY UNTESTED patch.
>
> .. and let's actually attach the patch this time.

That's odd. I got a "server error" from gmail. And again no attachment.

Maybe THIS time.

            Linus

--14dae9ccd516bb7bb804d5c7dabe
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hd7ozr3z0

IGtlcm5lbC9zb2Z0aXJxLmMgfCA2MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMoKyks
IDEzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9zb2Z0aXJxLmMgYi9rZXJuZWwv
c29mdGlycS5jCmluZGV4IGVkNTY3YmFiZTc4OS4uMzczNmI1MDljYWQ1IDEwMDY0NAotLS0gYS9r
ZXJuZWwvc29mdGlycS5jCisrKyBiL2tlcm5lbC9zb2Z0aXJxLmMKQEAgLTMyMCwyMCArMzIwLDUy
IEBAIHZvaWQgaXJxX2VudGVyKHZvaWQpCiAJX19pcnFfZW50ZXIoKTsKIH0KIAotc3RhdGljIGlu
bGluZSB2b2lkIGludm9rZV9zb2Z0aXJxKHZvaWQpCisjZGVmaW5lIHByZWVtcHRfdmFsdWVfaW5f
aW50ZXJydXB0KHZhbCkgXAorCSgodmFsKSAmIChIQVJESVJRX01BU0sgfCBTT0ZUSVJRX01BU0sg
fCBOTUlfTUFTSykpCisKKy8qCisgKiBJbnZvY2Ugc29mdGlycSdzIGZyb20gaXJxX2V4aXQoKS4K
KyAqCisgKiBSZXR1cm4gdGhlIHByZWVtcHQgb2Zmc2V0OiBlaXRoZXIgSVJRX0VYSVRfT0ZGU0VU
IChpZiB3ZQorICogZGlkIG5vdGhpbmcgdG8gdGhlIHByZWVtcHRpb24gY291bnQpIG9yIFNPRlRJ
UlFfT0ZGU0VUIChpbgorICogY2FzZSB3ZSBkaWQgc29mdGlycSBwcm9jZXNzaW5nIGFuZCBjaGFu
Z2VkIHRoZSBwcmVlbXB0aW9uCisgKiBjb3VudCB0byBhY2NvdW50IGZvciB0aGF0KS4KKyAqLwor
c3RhdGljIGlubGluZSBpbnQgaW52b2tlX3NvZnRpcnEodm9pZCkKIHsKLQlpZiAoIWZvcmNlX2ly
cXRocmVhZHMpIHsKKwlpbnQgb2Zmc2V0ID0gSVJRX0VYSVRfT0ZGU0VUOworCWludCBjb3VudCA9
IHByZWVtcHRfY291bnQoKSAtIG9mZnNldDsKKworCS8qIENhbiB3ZSBydW4gc29mdGlycSdzIGF0
IGFsbD8gV2UgbWlndGggYmUgbmVzdGluZyBpbnRlcnJ1cHRzICovCisJaWYgKHByZWVtcHRfdmFs
dWVfaW5faW50ZXJydXB0KGNvdW50KSkKKwkJcmV0dXJuIG9mZnNldDsKKworCS8qIEFyZSB0aGVy
ZSBhbnkgcGVuZGluZz8gKi8KKwlpZiAoIWxvY2FsX3NvZnRpcnFfcGVuZGluZygpKQorCQlyZXR1
cm4gb2Zmc2V0OworCisJLyogRG8gd2UgZm9yY2UgaXJxIHRocmVhZHM/IElmIHNvLCBqdXN0IHdh
a2UgdXAgdGhlIGRhZW1vbiAqLworCWlmIChmb3JjZV9pcnF0aHJlYWRzKSB7CisJCXdha2V1cF9z
b2Z0aXJxZCgpOworCQlyZXR1cm4gb2Zmc2V0OworCX0KKworCS8qCisJICogT2ssIGRvIGFjdHVh
bCBzb2Z0aXJxIGhhbmRsaW5nIQorCSAqCisJICogVGhpcyBkb3duZ3JhZGVzIHVzIGZyb20gaGFy
ZGlycSBjb250ZXh0IHRvIHNvZnRpcnEgY29udGV4dC4KKwkgKi8KKwlvZmZzZXQgPSBTT0ZUSVJR
X09GRlNFVDsKKwlwcmVlbXB0X2NvdW50KCkgPSBjb3VudCArIG9mZnNldDsKKworCXRyYWNlX3Nv
ZnRpcnFzX29mZihfX2J1aWx0aW5fcmV0dXJuX2FkZHJlc3MoMCkpOwogI2lmZGVmIF9fQVJDSF9J
UlFfRVhJVF9JUlFTX0RJU0FCTEVECi0JCV9fZG9fc29mdGlycSgpOworCV9fZG9fc29mdGlycSgp
OwogI2Vsc2UKLQkJZG9fc29mdGlycSgpOworCWRvX3NvZnRpcnEoKTsKICNlbmRpZgotCX0gZWxz
ZSB7Ci0JCV9fbG9jYWxfYmhfZGlzYWJsZSgodW5zaWduZWQgbG9uZylfX2J1aWx0aW5fcmV0dXJu
X2FkZHJlc3MoMCksCi0JCQkJU09GVElSUV9PRkZTRVQpOwotCQl3YWtldXBfc29mdGlycWQoKTsK
LQkJX19sb2NhbF9iaF9lbmFibGUoU09GVElSUV9PRkZTRVQpOwotCX0KKwl0cmFjZV9zb2Z0aXJx
c19vbigodW5zaWduZWQgbG9uZylfX2J1aWx0aW5fcmV0dXJuX2FkZHJlc3MoMCkpOworCXJldHVy
biBvZmZzZXQ7CiB9CiAKIC8qCkBAIC0zNDEsMTEgKzM3MywxMyBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgaW52b2tlX3NvZnRpcnEodm9pZCkKICAqLwogdm9pZCBpcnFfZXhpdCh2b2lkKQogeworCWlu
dCBvZmZzZXQ7CisKIAl2dGltZV9hY2NvdW50X2lycV9leGl0KGN1cnJlbnQpOwogCXRyYWNlX2hh
cmRpcnFfZXhpdCgpOwotCXN1Yl9wcmVlbXB0X2NvdW50KElSUV9FWElUX09GRlNFVCk7Ci0JaWYg
KCFpbl9pbnRlcnJ1cHQoKSAmJiBsb2NhbF9zb2Z0aXJxX3BlbmRpbmcoKSkKLQkJaW52b2tlX3Nv
ZnRpcnEoKTsKKworCW9mZnNldCA9IGludm9rZV9zb2Z0aXJxKCk7CisJc3ViX3ByZWVtcHRfY291
bnQob2Zmc2V0KTsKIAogI2lmZGVmIENPTkZJR19OT19IWgogCS8qIE1ha2Ugc3VyZSB0aGF0IHRp
bWVyIHdoZWVsIHVwZGF0ZXMgYXJlIHByb3BhZ2F0ZWQgKi8K
--14dae9ccd516bb7bb804d5c7dabe--
