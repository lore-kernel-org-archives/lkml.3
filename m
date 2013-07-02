Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3GBWz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:55:27 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58045 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3GBWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7oeYUWS+jaJqm-4i+tN0HuOZrrxZt7GDmeRSmj4pzYYQ@mail.gmail.com>
References: <20121030040237.GA10472@google.com>
	<1352003971-22278-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
	<CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
	<CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
	<CAE9FiQV5x1S1BNHrXq0wMRDx7PD5BoCh3fOnq2vS_AOAGL8Rrw@mail.gmail.com>
	<CAErSpo5vEb=63jGsqfau1G=f54oqq17pc3ZzcpzhL7hQrtYhng@mail.gmail.com>
	<CAE9FiQUxxjZmd3C33_ujSeL1EjcKHHSoGusQwfBD+Zd=cwCDZA@mail.gmail.com>
	<CAErSpo6qX3ih9DXLqxqJw141OAeTFu0YfSih6LyD0sd2gS-Vyg@mail.gmail.com>
	<CAErSpo7oeYUWS+jaJqm-4i+tN0HuOZrrxZt7GDmeRSmj4pzYYQ@mail.gmail.com>
Date: Tue, 2 Jul 2013 15:55:24 -0700
X-Google-Sender-Auth: h-kjqD9rAS-BLgdDoFBfn9fjd5M
Message-ID: <CAE9FiQWkecbt_+W1OGZNWk7MMaQZcNS-J2PkDvx6dxjaNKC32A@mail.gmail.com>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf3010ecc98d92fc04e08f3de3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3010ecc98d92fc04e08f3de3
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jul 2, 2013 at 2:31 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Jan 9, 2013 at 11:39 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, Jan 9, 2013 at 10:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
>>> the reason why we need to change those codes for x86, we want to make it support
>>> pci root bus hotplug. So it would be reasonable for us to align other
>>> platform to x86
>>> changes after pci root bus hotplug change is completely done.
>>
>> OK, I opened https://bugzilla.kernel.org/show_bug.cgi?id=52531 as a
>> way to keep track of this consistency issue ...
>
> What's your plan for this?  We desperately need more cross-arch
> consistency in how we manage resources, and I'd like to make some
> progress in this cycle.

Ok, will work on that.

but will on top of

[PATCH v5 0/7] PCI: Change assign unassigned resources per root bus bassis
and attached.

will resend them after v3.11-rc1 is out.

Thanks

Yinghai

--20cf3010ecc98d92fc04e08f3de3
Content-Type: application/octet-stream; 
	name="root_bus_ioport_skip_2_a.patch"
Content-Disposition: attachment; filename="root_bus_ioport_skip_2_a.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hinp268n0

U3ViamVjdDogW1BBVENIXSBQQ0k6IGNoZWNrIHBjaSBidXMgYWRkcmVzcyBmb3IgdW5hc3NpZ25l
ZCByZXMKCldlIHNob3VsZCBjb21wYXJlIHJlcy0+c3RhcnQgd2l0aCByb290IGJ1cyB3aW5kb3cg
b2Zmc2V0LgpPdGhlcndpc2Ugd2lsbCBoYXZlIHByb2JsZW0gd2l0aCBhcmNoIHRoYXQgc3VwcG9y
dCBob3N0YnJpZGdlCnJlc291cmNlIG9mZnNldC4KCkJlbkggcG9pbnRlZCBvdXQgdGhhdCBkdXJp
bmcgcmV2aWV3aW5nIHBhdGNoc2V0IHRoYXQgc2VwYXJhdGUKYXNzaWduIHVuYXNzaWduZWQgdG8g
cGVyIHJvb3QgYnVzZXMuCgpBY2NvcmRpbmcgdG8gQmpvcm4sIGhhdmUgaXQgaW4gc2VwYXJhdGVk
IHBhdGNoLgoKVXNlIHBjaWJpb3NfcmVzb3VyY2VfdG9fYnVzIHRvIGdldCByZWdpb24gYXQgZmly
c3QsIGFuZCBjaGVjawpyZWdpb24uc3RhcnQgaW5zdGVhZC4KClN1Z2dlc3RlZC1ieTogQmVuamFt
aW4gSGVycmVuc2NobWlkdCA8YmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnPgpTaWduZWQtb2ZmLWJ5
OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGRyaXZlcnMvcGNpL3NldHVw
LWJ1cy5jIHwgICAgNyArKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCisrKyBs
aW51eC0yLjYvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMKQEAgLTE0MjAsOSArMTQyMCwxNCBAQCBz
dGF0aWMgaW50IGNoZWNrX3VuYXNzaWduZWRfcmVzb3VyY2VzKHN0CiAKIAlmb3IgKGkgPSBQQ0lf
SU9WX1JFU09VUkNFUzsgaSA8PSBQQ0lfSU9WX1JFU09VUkNFX0VORDsgaSsrKSB7CiAJCXN0cnVj
dCByZXNvdXJjZSAqciA9ICZkZXYtPnJlc291cmNlW2ldOworCQlzdHJ1Y3QgcGNpX2J1c19yZWdp
b24gcmVnaW9uOwogCiAJCS8qIE5vdCBhc3NpZ25lZCwgb3IgcmVqZWN0ZWQgYnkga2VybmVsID8g
Ki8KLQkJaWYgKHItPmZsYWdzICYmICFyLT5zdGFydCkgeworCQlpZiAoIXItPmZsYWdzKQorCQkJ
Y29udGludWU7CisKKwkJcGNpYmlvc19yZXNvdXJjZV90b19idXMoZGV2LCAmcmVnaW9uLCByKTsK
KwkJaWYgKCFyZWdpb24uc3RhcnQpIHsKIAkJCSgqdW5hc3NpZ25lZCkrKzsKIAkJCXJldHVybiAx
OyAvKiByZXR1cm4gZWFybHkgZnJvbSBwY2lfd2Fsa19idXMgKi8KIAkJfQo=
--20cf3010ecc98d92fc04e08f3de3--
