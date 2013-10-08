Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JHMxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:53:23 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:34325 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab3JHMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <20131008121326.GB21581@sirena.org.uk>
References: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
 <20131008121326.GB21581@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 8 Oct 2013 14:52:58 +0200
Message-ID: <CACQ1gAjzanaYgP-pW0a+ahb+byH1FtAYp-Apfnc_LnUgpAiuCg@mail.gmail.com>
Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with SPI_IOC_MESSAGE
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e01227ca4ba00cc04e83a407c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01227ca4ba00cc04e83a407c
Content-Type: text/plain; charset=UTF-8

2013/10/8 Mark Brown <broonie@kernel.org>:
> On Tue, Oct 08, 2013 at 12:44:16PM +0200, Richard Genoud wrote:
>
>> I'm attaching the test software that I used ( ./spi_test /dev/spidevx.x )
>
> Looks like the attachment got forgotten?
arg !!!

thanks !
here it is. (I hope !! Since this morning, I have a *very*
discontinued internet acces with small shooting windows)

--089e01227ca4ba00cc04e83a407c
Content-Type: text/x-csrc; charset=US-ASCII; name="spi_test.c"
Content-Disposition: attachment; filename="spi_test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmj4phog1

I2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzdGRpby5o
PgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8
ZmNudGwuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3lzL2lvY3RsLmg+CiNpbmNs
dWRlIDxsaW51eC9zcGkvc3BpZGV2Lmg+CgoKI2RlZmluZSBTTUFMTCAyCiNkZWZpbmUgQklHIDEy
MAojZGVmaW5lIE5CIDMKCmNvbnN0IGludCBGSUxMX0JZVEUgPSAweGFhOwpjb25zdCBpbnQgUlhf
QllURSA9IDB4RkY7CmNvbnN0IHVuc2lnbmVkIGludCBNQVhfTE9PUFMgPSA1MDsKCnN0cnVjdCBz
cGlfaW9jX3RyYW5zZmVyIHhmZXJbTkJdOwpjaGFyIHJ4X2hlYWRlcltTTUFMTF07CmNoYXIgcnhf
YnVmZmVyW0JJR107CmNoYXIgcnhfZm9vdGVyW1NNQUxMXTsKY2hhciB0eF9oZWFkZXJbU01BTExd
OwpjaGFyIHR4X2J1ZmZlcltCSUddOwpjaGFyIHR4X2Zvb3RlcltTTUFMTF07Cgp2b2lkIGR1bXAo
Y2hhciAqYnVmLCB1bnNpZ25lZCBpbnQgbGVuKQp7Cgl1bnNpZ25lZCBpbnQgaTsKCglmb3IgKGkg
PSAwOyBpIDwgbGVuOyBpKyspIHsKCQlwcmludGYoIiUyLjJ4ICIsIGJ1ZltpXSk7CgkJaWYgKCgo
aSArIDEpICUgMTYpID09IDApCgkJCXByaW50ZigiXG4iKTsKCX0KCXByaW50ZigiXG4iKTsKfQoK
LyoKICogQ2hlY2tzIGlmIHRoZSBidWZmZXIgYnVmIGlzIGZpbGxlZCB3aXRoIHZhbCBieXRlcwog
KiByZXR1cm4gMCBpZiBpdCBpcywgMSBpZiBhIGJ5dGUgaXMgIT0gdmFsCiAqLwppbnQgY2hlY2tf
YnVmKGNoYXIgKmJ1ZiwgdW5zaWduZWQgaW50IGxlbiwgdW5zaWduZWQgaW50IHZhbCkKewoJd2hp
bGUgKGxlbi0tKQoJCWlmIChidWZbbGVuXSAhPSBSWF9CWVRFKQoJCQlyZXR1cm4gMTsKCXJldHVy
biAwOwp9Cgp2b2lkIHVzYWdlKGNvbnN0IGNoYXIgKnByb2duYW1lKQp7CglwcmludGYoIlVzYWdl
OiAlcyBzcGlkZXZcbiIsIHByb2duYW1lKTsKfQoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQp7Cgljb25zdCBjaGFyICpzcGlfZGV2X25hbWU7CglpbnQgZXJyID0gMDsKCWludCBmZDsK
CXVuc2lnbmVkIGludCBpOwoJdW5zaWduZWQgaW50IGxvb3BzID0gTUFYX0xPT1BTOwoKCWlmIChh
cmdjIDwgMikgewoJCXVzYWdlKGFyZ3ZbMF0pOwoJCWVyciA9IC0xOwoJCWdvdG8gb3V0OwoJfQoK
CXNwaV9kZXZfbmFtZSA9IGFyZ3ZbMV07CgoJZmQgPSBvcGVuKHNwaV9kZXZfbmFtZSwgT19SRFdS
KTsKCWlmIChmZCA8IDApIHsKCQlwZXJyb3IoIm9wZW4iKTsKCQllcnIgPSAtMTsKCQlnb3RvIG91
dDsKCX0KCgl4ZmVyWzBdLnR4X2J1ZiA9ICh1bnNpZ25lZCBsb25nKXR4X2hlYWRlcjsKCXhmZXJb
MF0ucnhfYnVmID0gKHVuc2lnbmVkIGxvbmcpcnhfaGVhZGVyOwoJeGZlclswXS5sZW4gPSBTTUFM
TDsKCXhmZXJbMV0udHhfYnVmID0gKHVuc2lnbmVkIGxvbmcpdHhfYnVmZmVyOwoJeGZlclsxXS5y
eF9idWYgPSAodW5zaWduZWQgbG9uZylyeF9idWZmZXI7Cgl4ZmVyWzFdLmxlbiA9IEJJRzsKCXhm
ZXJbMl0udHhfYnVmID0gKHVuc2lnbmVkIGxvbmcpdHhfZm9vdGVyOwoJeGZlclsyXS5yeF9idWYg
PSAodW5zaWduZWQgbG9uZylyeF9mb290ZXI7Cgl4ZmVyWzJdLmxlbiA9IFNNQUxMOwoKCXdoaWxl
IChsb29wcy0tKSB7CgkJZm9yIChpID0gMDsgaSA8IE5COyBpKyspIHsKCQkJbWVtc2V0KCh2b2lk
ICopeGZlcltpXS50eF9idWYsIEZJTExfQllURSwgeGZlcltpXS5sZW4pOwoJCQltZW1zZXQoKHZv
aWQgKil4ZmVyW2ldLnJ4X2J1ZiwgRklMTF9CWVRFLCB4ZmVyW2ldLmxlbik7CgkJfQoKCQllcnIg
PSBpb2N0bChmZCwgU1BJX0lPQ19NRVNTQUdFKE5CKSwgeGZlcik7CgkJaWYgKGVyciA8IDApIHsK
CQkJcGVycm9yKCJpb2N0bCIpOwoJCQlicmVhazsKCQl9CgkJaWYgKGVyciAhPSAoc2l6ZW9mKHJ4
X2J1ZmZlcikgKyBzaXplb2YocnhfZm9vdGVyKQoJCQkgICAgKyBzaXplb2YocnhfaGVhZGVyKSkp
IHsKCQkJcHJpbnRmKCJtZXNzYWdlIHRvbyBzaG9ydDogJWQgYnl0ZXNcbiIsIGVycik7CgkJCWJy
ZWFrOwoJCX0KCQlmb3IgKGkgPSAwOyBpIDwgTkI7IGkrKykgewoJCQllcnIgPSBjaGVja19idWYo
KGNoYXIgKikoeGZlcltpXS5yeF9idWYpLCB4ZmVyW2ldLmxlbiwgUlhfQllURSk7CgkJCWlmIChl
cnIpCgkJCQlkdW1wKChjaGFyICopKHhmZXJbaV0ucnhfYnVmKSwgeGZlcltpXS5sZW4pOwoJCX0K
CX0KCgkodm9pZCkgY2xvc2UoZmQpOwpvdXQ6CglyZXR1cm4gZXJyOwp9Cg==
--089e01227ca4ba00cc04e83a407c--
