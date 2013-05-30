Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3E3SMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:12:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62504 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab3E3SMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU=kC7J2Ocqy-Bq8rN-pO_2gDOrngwev_be70j=LLSpUg@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com>
	<3463581.AQ3EkyvJ7g@vostro.rjw.lan>
	<5738208.7rKb57pu5j@vostro.rjw.lan>
	<4462684.QmYxzGRhx8@vostro.rjw.lan>
	<CAE9FiQU=kC7J2Ocqy-Bq8rN-pO_2gDOrngwev_be70j=LLSpUg@mail.gmail.com>
Date: Thu, 30 May 2013 11:12:30 -0700
X-Google-Sender-Auth: 21aNY1Ri_Fk3ENTMdm8Vz0Gyh2U
Message-ID: <CAE9FiQWC=2yfVvFAMPQ7D5n5M8QNWROpcr6H-VwWZ+CSoyduyw@mail.gmail.com>
Subject: Re: System slow down from udev
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Content-Type: multipart/mixed; boundary=047d7b86e2b20cf39704ddf371f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b86e2b20cf39704ddf371f3
Content-Type: text/plain; charset=ISO-8859-1

On Thu, May 30, 2013 at 10:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, May 30, 2013 at 9:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> do you need to remove
>     per_cpu(processors, pr->id) = NULL;
> from processor_driver.c::acpi_processor_stop ?

updated patch.

--047d7b86e2b20cf39704ddf371f3
Content-Type: application/octet-stream; 
	name="rafael_fix_acpi_processor_x1.patch"
Content-Disposition: attachment; 
	filename="rafael_fix_acpi_processor_x1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhc9fmkr0

LS0tCiBkcml2ZXJzL2FjcGkvYWNwaV9wcm9jZXNzb3IuYyAgIHwgICAgNiArKysrKysKIGRyaXZl
cnMvYWNwaS9wcm9jZXNzb3JfZHJpdmVyLmMgfCAgICA0IC0tLS0KIDIgZmlsZXMgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJz
L2FjcGkvcHJvY2Vzc29yX2RyaXZlci5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2Ry
aXZlcnMvYWNwaS9wcm9jZXNzb3JfZHJpdmVyLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkv
cHJvY2Vzc29yX2RyaXZlci5jCkBAIC03OCw5ICs3OCw2IEBAIHN0YXRpYyBzdHJ1Y3QgZGV2aWNl
X2RyaXZlciBhY3BpX3Byb2Nlc3MKIAkucmVtb3ZlID0gYWNwaV9wcm9jZXNzb3Jfc3RvcCwKIH07
CiAKLURFRklORV9QRVJfQ1BVKHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqLCBwcm9jZXNzb3JzKTsK
LUVYUE9SVF9QRVJfQ1BVX1NZTUJPTChwcm9jZXNzb3JzKTsKLQogc3RhdGljIHZvaWQgYWNwaV9w
cm9jZXNzb3Jfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSwgdTMyIGV2ZW50LCB2b2lkICpkYXRh
KQogewogCXN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlID0gZGF0YTsKQEAgLTI2Niw3ICsyNjMs
NiBAQCBzdGF0aWMgaW50IGFjcGlfcHJvY2Vzc29yX3N0b3Aoc3RydWN0IGRlCiAJCXByLT5jZGV2
ID0gTlVMTDsKIAl9CiAKLQlwZXJfY3B1KHByb2Nlc3NvcnMsIHByLT5pZCkgPSBOVUxMOwogCXJl
dHVybiAwOwogfQogCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9hY3BpL2FjcGlfcHJvY2Vzc29y
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9hY3BpL2FjcGlfcHJvY2Vz
c29yLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvYWNwaV9wcm9jZXNzb3IuYwpAQCAtMjks
NiArMjksOSBAQAogCiBBQ1BJX01PRFVMRV9OQU1FKCJwcm9jZXNzb3IiKTsKIAorREVGSU5FX1BF
Ul9DUFUoc3RydWN0IGFjcGlfcHJvY2Vzc29yICosIHByb2Nlc3NvcnMpOworRVhQT1JUX1BFUl9D
UFVfU1lNQk9MKHByb2Nlc3NvcnMpOworCiAvKiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBFcnJhdGEgSGFuZGxpbmcKICAgIC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tICovCkBAIC0zODcsNiArMzkwLDcgQEAgc3RhdGljIGludCBfX2NwdWluaXQgYWNwaV9wcm9j
ZXNzb3JfYWRkKAogCSAqIGNoZWNrcy4KIAkgKi8KIAlwZXJfY3B1KHByb2Nlc3Nvcl9kZXZpY2Vf
YXJyYXksIHByLT5pZCkgPSBkZXZpY2U7CisJcGVyX2NwdShwcm9jZXNzb3JzLCBwci0+aWQpID0g
cHI7CiAKIAlkZXYgPSBnZXRfY3B1X2RldmljZShwci0+aWQpOwogCXJlc3VsdCA9IGFjcGlfYmlu
ZF9vbmUoZGV2LCBwci0+aGFuZGxlKTsKQEAgLTQwNiw2ICs0MTAsNyBAQCBzdGF0aWMgaW50IF9f
Y3B1aW5pdCBhY3BpX3Byb2Nlc3Nvcl9hZGQoCiAgZXJyOgogCWZyZWVfY3B1bWFza192YXIocHIt
PnRocm90dGxpbmcuc2hhcmVkX2NwdV9tYXApOwogCWRldmljZS0+ZHJpdmVyX2RhdGEgPSBOVUxM
OworCXBlcl9jcHUocHJvY2Vzc29ycywgcHItPmlkKSA9IE5VTEw7CiAgZXJyX2ZyZWVfcHI6CiAJ
a2ZyZWUocHIpOwogCXJldHVybiByZXN1bHQ7CkBAIC00NDAsNiArNDQ1LDcgQEAgc3RhdGljIHZv
aWQgYWNwaV9wcm9jZXNzb3JfcmVtb3ZlKHN0cnVjdAogCiAJLyogQ2xlYW4gdXAuICovCiAJcGVy
X2NwdShwcm9jZXNzb3JfZGV2aWNlX2FycmF5LCBwci0+aWQpID0gTlVMTDsKKwlwZXJfY3B1KHBy
b2Nlc3NvcnMsIHByLT5pZCkgPSBOVUxMOwogCXRyeV9vZmZsaW5lX25vZGUoY3B1X3RvX25vZGUo
cHItPmlkKSk7CiAKIAkvKiBSZW1vdmUgdGhlIENQVS4gKi8K
--047d7b86e2b20cf39704ddf371f3--
