Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3A2Vwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:52:34 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:63161 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2Vwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130129084914.GB5350@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
	<FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
	<CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
	<20130128101135.GD7168@gmail.com>
	<CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
	<20130129074746.GA594@gmail.com>
	<FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
	<20130129084914.GB5350@gmail.com>
Date: Tue, 29 Jan 2013 13:52:31 -0800
X-Google-Sender-Auth: fuQO6sdr_88e1D6dUar1aA0wons
Message-ID: <CAE9FiQXe2QHacwyJx+5MQWmoGYW1Swnr5M-MSircgfA4_9e19Q@mail.gmail.com>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: multipart/mixed; boundary=e89a8f3b9dbb18231704d474692c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f3b9dbb18231704d474692c
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 29, 2013 at 12:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Wang, Song-Bo (Stoney) <song-bo.wang@hp.com> wrote:
>
>> [...] Due to this mode mismatch, with specific HW
>> configurations, there will be intermittent lost interrupts,
>> which could result in a hang or data loss.
>
> That's the key piece of information that was missing - which
> should be put into the changelog into a very prominent place.
>
>> Logically, there is a mismatch because the kernel missed
>> detection on HW configurations, and we should fix it, right?
>> Do we need more detailed information?
>
> No, the above sentence is more than enough and the fix looks
> nice. Note that this sentence is more useful to users than the
> rest of the changelog combined!

Please check attached.

Thanks

Yinghai

--e89a8f3b9dbb18231704d474692c
Content-Type: application/octet-stream; name="wang_hp_x2apic.patch"
Content-Disposition: attachment; filename="wang_hp_x2apic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcjl0t5f0

RnJvbToJU3RvbmV5IFdhbmcgPHNvbmctYm8ud2FuZ0BocC5jb20+ClN1YmplY3Q6IFtQQVRDSF0g
eDg2LCBhcGljOiBDaGVjayBmYWR0IHgyYXBpYyBwaHlzIGluIHgyYXBpY19waHlzX3Byb2JlKCkK
CldoZW4gc29tZSBIUCBzeXRlbXMgYm9vdCB3aXRob3V0IHgyYXBpY19waHlzLCB0aGVyZSB3aWxs
IGJlIGludGVybWl0dGVudApsb3N0IGludGVycnVwdHMgYW5kIGNvdWxkIHJlc3VsdCBpbiBhIGhh
bmcgb3IgZGF0YSBsb3NzLgoKVGhvc2Ugc3lzdGVtcyBvbmx5IHdvcmsgd2l0aCB4MmFwaWMgcGh5
cyBtb2RlIHNvIEJJT1Mgc2V0CkFDUElfRkFEVF9BUElDX1BIWVNJQ0FMIGluIEZBRFQgdGFibGUu
CkFsc28gYmVjYXVzZSBhbGwgYXBpY2lkcyBhcmUgbGVzcyB0aGVuIDI1NSwgQklPUyBuZWVkIHRv
IHBhc3MgdGhlIGNvbnRyb2wKdG8gdGhlIE9TIHdpdGggeGFwaWMgbW9kZSwgYWNjb3JkaW5nIHRv
IHgyYXBpYy1zcGVjLCBjaGFwdGVyIDIuOS4KCkN1cnJlbnQgY29kZSBoYW5kbGUgeDJhcGljIHdo
ZW4gQklPUyBwYXNzIHdpdGggeGFwaWMgbW9kZToKCldoZW4gdXNlciBzcGVjaWZ5IHgyYXBpY19w
aHlzLCBvciBGQURUIGluZGljYXRlcyBQSFlTSUNBTC4KRHVyaW5nIG1hZHQgb2VtIGNoZWNrLCBh
cGljIGRyaXZlciBpcyBzZXQgd2l0aCB4YXBpYyBsb2dpY2FsIG9yCnhhcGljIHBoeXMgZHJpdmVy
IGF0IGZpcnN0LgpMYXRlciBlbmFibGVfSVJfeDJhcGljKCkgd2lsbCBlbmFibGUgeDJhcGljX21v
ZGUuCkFmdGVyIHRoYXQsIHgyYXBpY19waHlzX3Byb2JlKCkgd2lsbCBpbnN0YWxsIHJpZ2h0IHgy
YXBpYyBwaHlzIGRyaXZlcgppZiB1c2VyIHNwZWNpZnkgeDJhcGljX3BoeXMsCmJ1dCB3aWxsIHNr
aXAgYW5kIGxldCB4MmFwaWNfY2x1c3Rlcl9wcm9iZSB0byB0YWtlIG92ZXIgdG8gaW5zdGFsbAp3
cm9uZyBhcGljIGRyaXZlciAoeDJhcGljIGNsdXN0ZXIpIHdoZW4gRkFEVCBpbmRpY2F0ZXMKUEhZ
U0lDQUwsIGJlY2F1c2UgeDJhcGljX3BoeXNfcHJvYmUgZG9lcyBub3QgY2hlY2sgRkFEVCBQSFlT
SUNBTC4KCkFkZCBjaGVja2luZyB4MmFwaWNfZmFkdF9waHlzIGluIHgyYXBpY19waHlzX3Byb2Jl
KCkgdG8gZml4IHRoZSBwcm9ibGVtLgoKLXYzOiB1cGRhdGUgdGhlIGNoYW5nZSBhY2NvcmRpbmcg
dG8gSW5nby4KClsgY2hhbmdlbG9nLCBhbmQgc2ltcGxpZnkgY29kZSAtIFlpbmdoYWkgTHUgXQpT
aWduZWQtb2ZmLWJ5OiBTdG9uZXkgV2FuZyA8c29uZy1iby53YW5nQGhwLmNvbT4KU2lnbmVkLW9m
Zi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9rZXJu
ZWwvYXBpYy94MmFwaWNfcGh5cy5jIHwgICAyMSArKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL2FwaWMveDJhcGljX3BoeXMuYwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvYXBpYy94MmFwaWNfcGh5cy5jCisrKyBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL2FwaWMveDJhcGljX3BoeXMuYwpAQCAtMjAsMTggKzIwLDE5
IEBAIHN0YXRpYyBpbnQgc2V0X3gyYXBpY19waHlzX21vZGUoY2hhciAqYXIKIH0KIGVhcmx5X3Bh
cmFtKCJ4MmFwaWNfcGh5cyIsIHNldF94MmFwaWNfcGh5c19tb2RlKTsKIAotc3RhdGljIGludCB4
MmFwaWNfYWNwaV9tYWR0X29lbV9jaGVjayhjaGFyICpvZW1faWQsIGNoYXIgKm9lbV90YWJsZV9p
ZCkKK3N0YXRpYyBib29sIHgyYXBpY19mYWR0X3BoeXModm9pZCkKIHsKLQlpZiAoeDJhcGljX3Bo
eXMpCi0JCXJldHVybiB4MmFwaWNfZW5hYmxlZCgpOwotCWVsc2UgaWYgKChhY3BpX2dibF9GQURU
LmhlYWRlci5yZXZpc2lvbiA+PSBGQURUMl9SRVZJU0lPTl9JRCkgJiYKLQkJKGFjcGlfZ2JsX0ZB
RFQuZmxhZ3MgJiBBQ1BJX0ZBRFRfQVBJQ19QSFlTSUNBTCkgJiYKLQkJeDJhcGljX2VuYWJsZWQo
KSkgeworCWlmICgoYWNwaV9nYmxfRkFEVC5oZWFkZXIucmV2aXNpb24gPj0gRkFEVDJfUkVWSVNJ
T05fSUQpICYmCisJCShhY3BpX2dibF9GQURULmZsYWdzICYgQUNQSV9GQURUX0FQSUNfUEhZU0lD
QUwpKSB7CiAJCXByaW50ayhLRVJOX0RFQlVHICJTeXN0ZW0gcmVxdWlyZXMgeDJhcGljIHBoeXNp
Y2FsIG1vZGVcbiIpOwotCQlyZXR1cm4gMTsKKwkJcmV0dXJuIHRydWU7CiAJfQotCWVsc2UKLQkJ
cmV0dXJuIDA7CisJcmV0dXJuIGZhbHNlOworfQorCitzdGF0aWMgaW50IHgyYXBpY19hY3BpX21h
ZHRfb2VtX2NoZWNrKGNoYXIgKm9lbV9pZCwgY2hhciAqb2VtX3RhYmxlX2lkKQoreworCXJldHVy
biB4MmFwaWNfZW5hYmxlZCgpICYmICh4MmFwaWNfcGh5cyB8fCB4MmFwaWNfZmFkdF9waHlzKCkp
OwogfQogCiBzdGF0aWMgdm9pZApAQCAtODIsNyArODMsNyBAQCBzdGF0aWMgdm9pZCBpbml0X3gy
YXBpY19sZHIodm9pZCkKIAogc3RhdGljIGludCB4MmFwaWNfcGh5c19wcm9iZSh2b2lkKQogewot
CWlmICh4MmFwaWNfbW9kZSAmJiB4MmFwaWNfcGh5cykKKwlpZiAoeDJhcGljX21vZGUgJiYgKHgy
YXBpY19waHlzIHx8IHgyYXBpY19mYWR0X3BoeXMoKSkpCiAJCXJldHVybiAxOwogCiAJcmV0dXJu
IGFwaWMgPT0gJmFwaWNfeDJhcGljX3BoeXM7Cg==
--e89a8f3b9dbb18231704d474692c--
