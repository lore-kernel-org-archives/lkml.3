Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LRGuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:50:24 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:63640 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3LRGuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <0c18891f0a754978a3015c9b3b50df93@DM2PR05MB671.namprd05.prod.outlook.com>
References: <52B0AEAD.6050604@gmail.com>
	<20131218010207.GC15119@google.com>
	<41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
	<CAE9FiQVGQ8THfMBfEhaOnjbrdaRn+5CRoUoGZuVvRcZcAKqW_A@mail.gmail.com>
	<0c18891f0a754978a3015c9b3b50df93@DM2PR05MB671.namprd05.prod.outlook.com>
Date: Tue, 17 Dec 2013 22:50:21 -0800
X-Google-Sender-Auth: APVhlxnHPcsyGuUwAyWhYz4szdM
Message-ID: <CAE9FiQXkgLw6y2GmVvRStOAuqqOY=kTypLKY6YcvOhD2zOhdsw@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
From: Yinghai Lu <yinghai@kernel.org>
To: Rajat Jain <rajatjain@juniper.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatxjain@gmail.com>
Content-Type: multipart/mixed; boundary=e89a8f5038e278ebc504edc97532
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f5038e278ebc504edc97532
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Dec 17, 2013 at 10:17 PM, Rajat Jain <rajatjain@juniper.net> wrote:
> Well, in that case I doubt if the patch will solve the problem. I think
> Most likely the "card present / not present" messages may be replaced
> By "link-up / link-down" messages. But I'd appreciate your testing.

I did have a debug patch at that time to report link status change.
And it did report link up and link down.

Thanks

Yinghai

--e89a8f5038e278ebc504edc97532
Content-Type: text/x-patch; charset=US-ASCII; name="link_change_report.patch"
Content-Disposition: attachment; filename="link_change_report.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpc7zn8p0

U3ViamVjdDogW1BBVENIXSBQQ0ksIHBjaWVocDogUmVwb3J0IHBjaWUgbGluayBzdGF0ZSBjaGFu
Z2UKClRvIHNlZSBpZiB0aGVyZSBpcyBzb21lIGxpbmsgc3RhdGUgY2hhbmdlLgoKU2lnbmVkLW9m
Zi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBkcml2ZXJzL3BjaS9o
b3RwbHVnL3BjaWVocF9ocGMuYyB8ICAgMjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0K
IDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6
IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9ocGMuYwo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0t
LSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9ob3RwbHVnL3BjaWVocF9ocGMuYworKysgbGlu
dXgtMi42L2RyaXZlcnMvcGNpL2hvdHBsdWcvcGNpZWhwX2hwYy5jCkBAIC02MDMsNiArNjAzLDI1
IEBAIGludCBwY2llaHBfcG93ZXJfb2ZmX3Nsb3Qoc3RydWN0IHNsb3QgKgogCXJldHVybiAwOwog
fQogCitzdGF0aWMgdTggcGNpZWhwX2hhbmRsZV9saW5rc3RhdGVfY2hhbmdlKHN0cnVjdCBzbG90
ICpzbG90KQoreworCXN0cnVjdCBjb250cm9sbGVyICpjdHJsID0gc2xvdC0+Y3RybDsKKwl1MTYg
bG5rX3N0YXR1czsKKwlpbnQgcmV0dmFsOworCisgICAgICAgIC8qIExpbmtTdGF0ZSBDaGFuZ2Ug
Ki8KKwljdHJsX2RiZyhjdHJsLCAiTGlua1N0YXRlIGNoYW5nZVxuIik7CisKKwlyZXR2YWwgPSBw
Y2llaHBfcmVhZHcoY3RybCwgUENJX0VYUF9MTktTVEEsICZsbmtfc3RhdHVzKTsKKwlpZiAocmV0
dmFsKSB7CisJCWN0cmxfZXJyKGN0cmwsICJDYW5ub3QgcmVhZCBMTktTVEFUVVMgcmVnaXN0ZXJc
biIpOworCQlyZXR1cm4gMTsKKwl9CisJY3RybF9pbmZvKGN0cmwsICJsbmtfc3RhdHVzID0gJXhc
biIsIGxua19zdGF0dXMpOworCisJcmV0dXJuIDE7Cit9CisKIHN0YXRpYyBpcnFyZXR1cm5fdCBw
Y2llX2lzcihpbnQgaXJxLCB2b2lkICpkZXZfaWQpCiB7CiAJc3RydWN0IGNvbnRyb2xsZXIgKmN0
cmwgPSAoc3RydWN0IGNvbnRyb2xsZXIgKilkZXZfaWQ7CkBAIC02MjQsNyArNjQzLDcgQEAgc3Rh
dGljIGlycXJldHVybl90IHBjaWVfaXNyKGludCBpcnEsIHZvaQogCiAJCWRldGVjdGVkICY9IChQ
Q0lfRVhQX1NMVFNUQV9BQlAgfCBQQ0lfRVhQX1NMVFNUQV9QRkQgfAogCQkJICAgICBQQ0lfRVhQ
X1NMVFNUQV9NUkxTQyB8IFBDSV9FWFBfU0xUU1RBX1BEQyB8Ci0JCQkgICAgIFBDSV9FWFBfU0xU
U1RBX0NDKTsKKwkJCSAgICAgUENJX0VYUF9TTFRTVEFfQ0MgfCBQQ0lfRVhQX1NMVFNUQV9ETExT
Qyk7CiAJCWRldGVjdGVkICY9IH5pbnRyX2xvYzsKIAkJaW50cl9sb2MgfD0gZGV0ZWN0ZWQ7CiAJ
CWlmICghaW50cl9sb2MpCkBAIC02NDgsNiArNjY3LDEwIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBw
Y2llX2lzcihpbnQgaXJxLCB2b2kKIAlpZiAoIShpbnRyX2xvYyAmIH5QQ0lfRVhQX1NMVFNUQV9D
QykpCiAJCXJldHVybiBJUlFfSEFORExFRDsKIAorCS8qIENoZWNrIExpbmsgU3RhdGUgQ2hhbmdl
ZCAqLworCWlmIChpbnRyX2xvYyAmIFBDSV9FWFBfU0xUU1RBX0RMTFNDKQorCQlwY2llaHBfaGFu
ZGxlX2xpbmtzdGF0ZV9jaGFuZ2Uoc2xvdCk7CisKIAkvKiBDaGVjayBNUkwgU2Vuc29yIENoYW5n
ZWQgKi8KIAlpZiAoaW50cl9sb2MgJiBQQ0lfRVhQX1NMVFNUQV9NUkxTQykKIAkJcGNpZWhwX2hh
bmRsZV9zd2l0Y2hfY2hhbmdlKHNsb3QpOwpAQCAtNjg5LDEwICs3MTIsMTIgQEAgaW50IHBjaWVf
ZW5hYmxlX25vdGlmaWNhdGlvbihzdHJ1Y3QgY29udAogCQljbWQgfD0gUENJX0VYUF9TTFRDVExf
TVJMU0NFOwogCWlmICghcGNpZWhwX3BvbGxfbW9kZSkKIAkJY21kIHw9IFBDSV9FWFBfU0xUQ1RM
X0hQSUUgfCBQQ0lfRVhQX1NMVENUTF9DQ0lFOworCWNtZCB8PSBQQ0lfRVhQX1NMVENUTF9ETExT
Q0U7CiAKIAltYXNrID0gKFBDSV9FWFBfU0xUQ1RMX1BEQ0UgfCBQQ0lfRVhQX1NMVENUTF9BQlBF
IHwKIAkJUENJX0VYUF9TTFRDVExfTVJMU0NFIHwgUENJX0VYUF9TTFRDVExfUEZERSB8Ci0JCVBD
SV9FWFBfU0xUQ1RMX0hQSUUgfCBQQ0lfRVhQX1NMVENUTF9DQ0lFKTsKKwkJUENJX0VYUF9TTFRD
VExfSFBJRSB8IFBDSV9FWFBfU0xUQ1RMX0NDSUUgfAorCQlQQ0lfRVhQX1NMVENUTF9ETExTQ0Up
OwogCiAJaWYgKHBjaWVfd3JpdGVfY21kKGN0cmwsIGNtZCwgbWFzaykpIHsKIAkJY3RybF9lcnIo
Y3RybCwgIkNhbm5vdCBlbmFibGUgc29mdHdhcmUgbm90aWZpY2F0aW9uXG4iKTsK
--e89a8f5038e278ebc504edc97532--
