Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3AaEyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:54:55 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58218 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3AaEyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <ddc1bb4ed278819ffc7fac229134c01e17f03477.1359607980.git.viresh.kumar@linaro.org>
References: <ddc1bb4ed278819ffc7fac229134c01e17f03477.1359607980.git.viresh.kumar@linaro.org>
Date: Thu, 31 Jan 2013 10:24:51 +0530
Message-ID: <CAKohpo=w+fAv3k2M7MXFbss0u52jzXCRHdoTw8fKSbSaN2jrFA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: SPEAr: Notify all policy->cpus of frequency change
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: multipart/mixed; boundary=bcaec54d476656c53004d48e6da8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54d476656c53004d48e6da8
Content-Type: text/plain; charset=ISO-8859-1

On 31 January 2013 10:23, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> SPEAr cpufreq driver supports dual core Cortex-A9 SoC's, where cpus share policy
> structure. Whenever we update frequency of a cpu, we must notify all
> policy->cpus.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Find it attached too.

--bcaec54d476656c53004d48e6da8
Content-Type: application/octet-stream; 
	name="0001-cpufreq-SPEAr-Notify-all-policy-cpus-of-frequency-ch.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-SPEAr-Notify-all-policy-cpus-of-frequency-ch.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hclfjs6f0

RnJvbSBkZGMxYmI0ZWQyNzg4MTlmZmM3ZmFjMjI5MTM0YzAxZTE3ZjAzNDc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZGRjMWJiNGVkMjc4ODE5ZmZjN2ZhYzIyOTEzNGMw
MWUxN2YwMzQ3Ny4xMzU5NjA3OTgwLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVGh1LCAzMSBKYW4g
MjAxMyAxMDoxNzozMiArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IFNQRUFyOiBOb3Rp
ZnkgYWxsIHBvbGljeS0+Y3B1cyBvZiBmcmVxdWVuY3kgY2hhbmdlCgpTUEVBciBjcHVmcmVxIGRy
aXZlciBzdXBwb3J0cyBkdWFsIGNvcmUgQ29ydGV4LUE5IFNvQydzLCB3aGVyZSBjcHVzIHNoYXJl
IHBvbGljeQpzdHJ1Y3R1cmUuIFdoZW5ldmVyIHdlIHVwZGF0ZSBmcmVxdWVuY3kgb2YgYSBjcHUs
IHdlIG11c3Qgbm90aWZ5IGFsbApwb2xpY3ktPmNwdXMuCgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2gg
S3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9zcGVh
ci1jcHVmcmVxLmMgfCA3ICsrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL3NwZWFyLWNwdWZy
ZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9zcGVhci1jcHVmcmVxLmMKaW5kZXggNDU3NWNmZS4uNjNj
NmE3ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL3NwZWFyLWNwdWZyZXEuYworKysgYi9k
cml2ZXJzL2NwdWZyZXEvc3BlYXItY3B1ZnJlcS5jCkBAIC0xNTcsNyArMTU3LDkgQEAgc3RhdGlj
IGludCBzcGVhcl9jcHVmcmVxX3RhcmdldChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwK
IAogCWZyZXFzLm5ldyA9IG5ld2ZyZXEgLyAxMDAwOwogCWZyZXFzLm5ldyAvPSBtdWx0OwotCWNw
dWZyZXFfbm90aWZ5X3RyYW5zaXRpb24oJmZyZXFzLCBDUFVGUkVRX1BSRUNIQU5HRSk7CisKKwlm
b3JfZWFjaF9jcHUoZnJlcXMuY3B1LCBwb2xpY3ktPmNwdXMpCisJCWNwdWZyZXFfbm90aWZ5X3Ry
YW5zaXRpb24oJmZyZXFzLCBDUFVGUkVRX1BSRUNIQU5HRSk7CiAKIAlpZiAobXVsdCA9PSAyKQog
CQlyZXQgPSBzcGVhcjEzNDBfc2V0X2NwdV9yYXRlKHNyY2NsaywgbmV3ZnJlcSk7CkBAIC0xNzAs
NyArMTcyLDggQEAgc3RhdGljIGludCBzcGVhcl9jcHVmcmVxX3RhcmdldChzdHJ1Y3QgY3B1ZnJl
cV9wb2xpY3kgKnBvbGljeSwKIAkJZnJlcXMubmV3ID0gY2xrX2dldF9yYXRlKHNwZWFyX2NwdWZy
ZXEuY2xrKSAvIDEwMDA7CiAJfQogCi0JY3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbigmZnJlcXMs
IENQVUZSRVFfUE9TVENIQU5HRSk7CisJZm9yX2VhY2hfY3B1KGZyZXFzLmNwdSwgcG9saWN5LT5j
cHVzKQorCQljcHVmcmVxX25vdGlmeV90cmFuc2l0aW9uKCZmcmVxcywgQ1BVRlJFUV9QT1NUQ0hB
TkdFKTsKIAlyZXR1cm4gcmV0OwogfQogCi0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--bcaec54d476656c53004d48e6da8--
