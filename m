Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646Ab3E2Ky6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:54:58 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:37061 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965598Ab3E2Ky4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <1369824422.22004.101.camel@joe-AO722>
References: <aab5b5dc92b960e81e8fd1975eba81234a4ecac8.1369817795.git.viresh.kumar@linaro.org>
	<1369824422.22004.101.camel@joe-AO722>
Date: Wed, 29 May 2013 16:24:55 +0530
Message-ID: <CAKohpomz4qOmhy-VRb2n0CY7YOr0vP3EGo88iXBhm2MzsJ8rrw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: MAINTAINERS: Add git tree path for ARM specific updates
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: multipart/mixed; boundary=047d7b6da78252e25404ddd93691
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6da78252e25404ddd93691
Content-Type: text/plain; charset=ISO-8859-1

On 29 May 2013 16:17, Joe Perches <joe@perches.com> wrote:
> On Wed, 2013-05-29 at 16:10 +0530, Viresh Kumar wrote:
>> ARM specific patches would be
>> Applied by me now. Rafael will pull in these changes from time to time (at
>> rc's).
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -2216,6 +2216,7 @@ L:      cpufreq@vger.kernel.org
> []
>>  T:   git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
>> +T:   git://git.linaro.org/people/vireshk/linux.git (For ARM Updates)
>
> please prefix these with git
>
> T:      git git://git.etc...
>
> Every other T: git entry does.
>

Thanks for reporting it.. below commit must be fixing it..
@Rafael: attached for you to apply.

----------x-------------------x------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 29 May 2013 12:23:14 +0530
Subject: [PATCH] cpufreq: MAINTAINERS: Add git tree path for ARM specific
 updates

To reduce cpufreq maintenance load on Rafael, ARM specific patches would be
Applied by me now. Rafael will pull in these changes from time to time (at
rc's). Additionally I would be sending him pull request for every merge window
and rc's (for fixes).

Web interface of my tree is present here:

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=summary

Branch names would be: cpufreq-next and cpufreq-fixes.

This also prefixes tree path with "git ".

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..92a6624 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2215,7 +2215,8 @@ M:	Viresh Kumar <viresh.kumar@linaro.org>
 L:	cpufreq@vger.kernel.org
 L:	linux-pm@vger.kernel.org
 S:	Maintained
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git git://git.linaro.org/people/vireshk/linux.git (For ARM Updates)
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h

--047d7b6da78252e25404ddd93691
Content-Type: application/octet-stream; 
	name="0001-cpufreq-MAINTAINERS-Add-git-tree-path-for-ARM-specif.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-MAINTAINERS-Add-git-tree-path-for-ARM-specif.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhaecwv30

RnJvbSBhMWZjNGI3MDM0OTYwMjgwMGExYjg0ZjhlZTRiYWI3ZTA1ZmJlMjRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8YTFmYzRiNzAzNDk2MDI4MDBhMWI4NGY4ZWU0YmFi
N2UwNWZiZTI0Zi4xMzY5ODI0ODE1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogV2VkLCAyOSBNYXkg
MjAxMyAxMjoyMzoxNCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IE1BSU5UQUlORVJT
OiBBZGQgZ2l0IHRyZWUgcGF0aCBmb3IgQVJNIHNwZWNpZmljCiB1cGRhdGVzCgpUbyByZWR1Y2Ug
Y3B1ZnJlcSBtYWludGVuYW5jZSBsb2FkIG9uIFJhZmFlbCwgQVJNIHNwZWNpZmljIHBhdGNoZXMg
d291bGQgYmUKQXBwbGllZCBieSBtZSBub3cuIFJhZmFlbCB3aWxsIHB1bGwgaW4gdGhlc2UgY2hh
bmdlcyBmcm9tIHRpbWUgdG8gdGltZSAoYXQKcmMncykuIEFkZGl0aW9uYWxseSBJIHdvdWxkIGJl
IHNlbmRpbmcgaGltIHB1bGwgcmVxdWVzdCBmb3IgZXZlcnkgbWVyZ2Ugd2luZG93CmFuZCByYydz
IChmb3IgZml4ZXMpLgoKV2ViIGludGVyZmFjZSBvZiBteSB0cmVlIGlzIHByZXNlbnQgaGVyZToK
Cmh0dHBzOi8vZ2l0LmxpbmFyby5vcmcvZ2l0d2ViP3A9cGVvcGxlL3ZpcmVzaGsvbGludXguZ2l0
O2E9c3VtbWFyeQoKQnJhbmNoIG5hbWVzIHdvdWxkIGJlOiBjcHVmcmVxLW5leHQgYW5kIGNwdWZy
ZXEtZml4ZXMuCgpUaGlzIGFsc28gcHJlZml4ZXMgdHJlZSBwYXRoIHdpdGggImdpdCAiLgoKU2ln
bmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBN
QUlOVEFJTkVSUyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCBm
ZDNhNDk1Li45MmE2NjI0IDEwMDY0NAotLS0gYS9NQUlOVEFJTkVSUworKysgYi9NQUlOVEFJTkVS
UwpAQCAtMjIxNSw3ICsyMjE1LDggQEAgTToJVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGlu
YXJvLm9yZz4KIEw6CWNwdWZyZXFAdmdlci5rZXJuZWwub3JnCiBMOglsaW51eC1wbUB2Z2VyLmtl
cm5lbC5vcmcKIFM6CU1haW50YWluZWQKLVQ6CWdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9yYWZhZWwvbGludXgtcG0uZ2l0CitUOglnaXQgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JhZmFlbC9saW51eC1wbS5naXQKK1Q6
CWdpdCBnaXQ6Ly9naXQubGluYXJvLm9yZy9wZW9wbGUvdmlyZXNoay9saW51eC5naXQgKEZvciBB
Uk0gVXBkYXRlcykKIEY6CWRyaXZlcnMvY3B1ZnJlcS8KIEY6CWluY2x1ZGUvbGludXgvY3B1ZnJl
cS5oCiAKLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--047d7b6da78252e25404ddd93691--
