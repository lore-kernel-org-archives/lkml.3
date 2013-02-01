Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3BAGlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:41:35 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:43556 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3BAGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:41:33 -0500
MIME-Version: 1.0
In-Reply-To: <e76624720ca471d11ecd45628464d97e9eb513c9.1359700706.git.viresh.kumar@linaro.org>
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
	<e76624720ca471d11ecd45628464d97e9eb513c9.1359700706.git.viresh.kumar@linaro.org>
Date: Fri, 1 Feb 2013 12:11:31 +0530
Message-ID: <CAKohpokS=ajMQXCx4WbZn0BKZXRQ4RUnchH=ZhQ_+XB03L4HTw@mail.gmail.com>
Subject: Re: [PATCH 2/3] cpufreq: Set all cpus in policy->cpus for single
 cluster SoCs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        spear-devel@list.st.com
Content-Type: multipart/mixed; boundary=f46d044788fdb2401b04d4a4081a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d044788fdb2401b04d4a4081a
Content-Type: text/plain; charset=ISO-8859-1

On 1 February 2013 12:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> With following patch, we need to set policy->cpus with mask of all possible cpus
> and policy->related_cpus would be filled automatically by the core.
>
> commit 4948b355e90080cd5ec1e91189f65a01e4186ef2
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Tue Jan 29 14:39:08 2013 +0000
>
> cpufreq: Simplify cpufreq_add_dev()
>
> Lets fix it for all single cluster SoCs.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: spear-devel@list.st.com
> ---
>  drivers/cpufreq/db8500-cpufreq.c | 2 +-
>  drivers/cpufreq/maple-cpufreq.c  | 2 +-
>  drivers/cpufreq/spear-cpufreq.c  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

ARM mail servers are broken, please find patch attached.

--f46d044788fdb2401b04d4a4081a
Content-Type: application/octet-stream; 
	name="0002-cpufreq-Set-all-cpus-in-policy-cpus-for-single-clust.patch"
Content-Disposition: attachment; 
	filename="0002-cpufreq-Set-all-cpus-in-policy-cpus-for-single-clust.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcmysszh0

RnJvbSBlNzY2MjQ3MjBjYTQ3MWQxMWVjZDQ1NjI4NDY0ZDk3ZTllYjUxM2M5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZTc2NjI0NzIwY2E0NzFkMTFlY2Q0NTYyODQ2NGQ5
N2U5ZWI1MTNjOS4xMzU5NzAwNzA2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KSW4tUmVw
bHktVG86IDwxYmY4MjQ1NGFiMWYxNmIxMzIxMjU0OGQ3Yzk2MDUwNjdjOGI3YTBkLjEzNTk3MDA3
MDUuZ2l0LnZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpSZWZlcmVuY2VzOiA8MWJmODI0NTRhYjFm
MTZiMTMyMTI1NDhkN2M5NjA1MDY3YzhiN2EwZC4xMzU5NzAwNzA1LmdpdC52aXJlc2gua3VtYXJA
bGluYXJvLm9yZz4KRnJvbTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
RGF0ZTogRnJpLCAxIEZlYiAyMDEzIDExOjI3OjU5ICswNTMwClN1YmplY3Q6IFtQQVRDSCAyLzNd
IGNwdWZyZXE6IFNldCBhbGwgY3B1cyBpbiBwb2xpY3ktPmNwdXMgZm9yIHNpbmdsZSBjbHVzdGVy
CiBTb0NzCgpXaXRoIGZvbGxvd2luZyBwYXRjaCwgd2UgbmVlZCB0byBzZXQgcG9saWN5LT5jcHVz
IHdpdGggbWFzayBvZiBhbGwgcG9zc2libGUgY3B1cwphbmQgcG9saWN5LT5yZWxhdGVkX2NwdXMg
d291bGQgYmUgZmlsbGVkIGF1dG9tYXRpY2FsbHkgYnkgdGhlIGNvcmUuCgpjb21taXQgNDk0OGIz
NTVlOTAwODBjZDVlYzFlOTExODlmNjVhMDFlNDE4NmVmMgpBdXRob3I6IFZpcmVzaCBLdW1hciA8
dmlyZXNoLmt1bWFyQGxpbmFyby5vcmc+CkRhdGU6ICAgVHVlIEphbiAyOSAxNDozOTowOCAyMDEz
ICswMDAwCgpjcHVmcmVxOiBTaW1wbGlmeSBjcHVmcmVxX2FkZF9kZXYoKQoKTGV0cyBmaXggaXQg
Zm9yIGFsbCBzaW5nbGUgY2x1c3RlciBTb0NzLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFy
IDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KQ2M6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxl
aWpAbGluYXJvLm9yZz4KQ2M6IERtaXRyeSBFcmVtaW4tU29sZW5pa292IDxkYmFyeXNoa292QGdt
YWlsLmNvbT4KQ2M6IHNwZWFyLWRldmVsQGxpc3Quc3QuY29tCi0tLQogZHJpdmVycy9jcHVmcmVx
L2RiODUwMC1jcHVmcmVxLmMgfCAyICstCiBkcml2ZXJzL2NwdWZyZXEvbWFwbGUtY3B1ZnJlcS5j
ICB8IDIgKy0KIGRyaXZlcnMvY3B1ZnJlcS9zcGVhci1jcHVmcmVxLmMgIHwgMiArLQogMyBmaWxl
cyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcHVmcmVxL2RiODUwMC1jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvZGI4NTAw
LWNwdWZyZXEuYwppbmRleCA0ZjE1NGJjLi5lMTJkZmY2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Nw
dWZyZXEvZGI4NTAwLWNwdWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvZGI4NTAwLWNwdWZy
ZXEuYwpAQCAtMTI4LDcgKzEyOCw3IEBAIHN0YXRpYyBpbnQgX19jcHVpbml0IGRiODUwMF9jcHVm
cmVxX2luaXQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3kpCiAJcG9saWN5LT5jcHVpbmZv
LnRyYW5zaXRpb25fbGF0ZW5jeSA9IDIwICogMTAwMDsgLyogaW4gbnMgKi8KIAogCS8qIHBvbGlj
eSBzaGFyaW5nIGJldHdlZW4gZHVhbCBDUFVzICovCi0JY3B1bWFza19jb3B5KHBvbGljeS0+Y3B1
cywgY3B1X3ByZXNlbnRfbWFzayk7CisJY3B1bWFza19zZXRhbGwocG9saWN5LT5jcHVzKTsKIAog
CXBvbGljeS0+c2hhcmVkX3R5cGUgPSBDUFVGUkVRX1NIQVJFRF9UWVBFX0FMTDsKIApkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jcHVmcmVxL21hcGxlLWNwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9t
YXBsZS1jcHVmcmVxLmMKaW5kZXggODliMTc4YS4uZDRjNDk4OSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9jcHVmcmVxL21hcGxlLWNwdWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvbWFwbGUtY3B1
ZnJlcS5jCkBAIC0xODEsNyArMTgxLDcgQEAgc3RhdGljIGludCBtYXBsZV9jcHVmcmVxX2NwdV9p
bml0KHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5KQogCS8qIHNlY29uZGFyeSBDUFVzIGFy
ZSB0aWVkIHRvIHRoZSBwcmltYXJ5IG9uZSBieSB0aGUKIAkgKiBjcHVmcmVxIGNvcmUgaWYgaW4g
dGhlIHNlY29uZGFyeSBwb2xpY3kgd2UgdGVsbCBpdCB0aGF0CiAJICogaXQgYWN0dWFsbHkgbXVz
dCBiZSBvbmUgcG9saWN5IHRvZ2V0aGVyIHdpdGggYWxsIG90aGVycy4gKi8KLQljcHVtYXNrX2Nv
cHkocG9saWN5LT5jcHVzLCBjcHVfb25saW5lX21hc2spOworCWNwdW1hc2tfc2V0YWxsKHBvbGlj
eS0+Y3B1cyk7CiAJY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfZ2V0X2F0dHIobWFwbGVfY3B1X2Zy
ZXFzLCBwb2xpY3ktPmNwdSk7CiAKIAlyZXR1cm4gY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfY3B1
aW5mbyhwb2xpY3ksCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvc3BlYXItY3B1ZnJlcS5j
IGIvZHJpdmVycy9jcHVmcmVxL3NwZWFyLWNwdWZyZXEuYwppbmRleCBmYzcxNGE2Li44MTI2MDg0
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvc3BlYXItY3B1ZnJlcS5jCisrKyBiL2RyaXZl
cnMvY3B1ZnJlcS9zcGVhci1jcHVmcmVxLmMKQEAgLTE4OCw3ICsxODgsNyBAQCBzdGF0aWMgaW50
IHNwZWFyX2NwdWZyZXFfaW5pdChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIAlwb2xp
Y3ktPmNwdWluZm8udHJhbnNpdGlvbl9sYXRlbmN5ID0gc3BlYXJfY3B1ZnJlcS50cmFuc2l0aW9u
X2xhdGVuY3k7CiAJcG9saWN5LT5jdXIgPSBzcGVhcl9jcHVmcmVxX2dldCgwKTsKIAotCWNwdW1h
c2tfY29weShwb2xpY3ktPmNwdXMsIHRvcG9sb2d5X2NvcmVfY3B1bWFzayhwb2xpY3ktPmNwdSkp
OworCWNwdW1hc2tfc2V0YWxsKHBvbGljeS0+Y3B1cyk7CiAKIAlyZXR1cm4gMDsKIH0KLS0gCjEu
Ny4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--f46d044788fdb2401b04d4a4081a--
