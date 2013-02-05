Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3BEKuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:50:24 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43247 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3BEKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:50:22 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUU4JMfws_jFpoCaXnSNJeigONSEik_oGSa_ZQ=uJ_GJOA@mail.gmail.com>
References: <CA+icZUW5tBotrZT9QtNPao-3rEccohBW8a4diS2nJ+ONgTWLaQ@mail.gmail.com>
	<CAKMK7uEFCm5JPD9bg4uO9K_q-w0=9GWzRLoB9H-_=ZR7NxA9=A@mail.gmail.com>
	<CA+icZUU4JMfws_jFpoCaXnSNJeigONSEik_oGSa_ZQ=uJ_GJOA@mail.gmail.com>
Date: Tue, 5 Feb 2013 11:50:21 +0100
Message-ID: <CA+icZUUvvq72yG9x1G_QhX31fZnuH_A=TxUmVyavz=7jw+RbqA@mail.gmail.com>
Subject: Re: Revert "console: implement lockdep support for console_lock"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: multipart/mixed; boundary=047d7b6d88b0eefad504d4f7f9de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6d88b0eefad504d4f7f9de
Content-Type: text/plain; charset=UTF-8

On Tue, Feb 5, 2013 at 11:47 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Feb 1, 2013 at 9:42 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> On Fri, Feb 1, 2013 at 9:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> people having the fbcon-locking-fixes [1] in their local GIT tree can
>>> revert this change?
>>
>> Yeah, if you have all the fixes reverting this is fine and appreciated
>> to increase testing. Dave will probably push the revert himself to
>> drm-next soon.
>
> When will that happen: drm-next inclusion?
>
> Just FYI:
> Pulling fbcon-locking-fixes into Linux-Next (next-20130205) shows some
> ugly UTF-8 mismatch, means "fb: rework locking to fix lock ordering on
> takeover" is not the same patch as in -next.
> Just wanna let you know.
>
> It would be good to inform Andrew and Stephen when this happened, so
> Andrew can drop the two fb-fixes from his mmotm-tree.
>

Attached the UTF-8 "mismatch" in vt.c.

- Sedat -

> Thanks!
>
> - Sedat -
>
>> -Daniel
>>
>>>
>>> commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf
>>> Refs: v3.8-rc5-194-gff0d05b
>>> Author:     Dave Airlie <airlied@gmail.com>
>>> AuthorDate: Thu Jan 31 14:27:03 2013 +1100
>>> Commit:     Dave Airlie <airlied@gmail.com>
>>> CommitDate: Thu Jan 31 15:46:56 2013 +1100
>>>
>>>     Revert "console: implement lockdep support for console_lock"
>>>
>>>     This reverts commit daee779718a319ff9f83e1ba3339334ac650bb22.
>>>
>>>     I'll requeue this after the console locking fixes, so lockdep
>>>     is useful again for people until fbcon is fixed.
>>>
>>>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>>>
>>> Thanks!
>>>
>>> Regards,
>>> - Sedat
>>>
>>> [1] http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
>>
>>
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

--047d7b6d88b0eefad504d4f7f9de
Content-Type: application/octet-stream; name="VT_C_UTF-8_CRAP.diff"
Content-Disposition: attachment; filename="VT_C_UTF-8_CRAP.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcsxgb1u0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3Z0L3Z0LmMgYi9kcml2ZXJzL3R0eS92dC92dC5jCmlu
ZGV4IDU2ZGQ2OWMuLjg2Yjc2ZjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdHR5L3Z0L3Z0LmMKKysr
IGIvZHJpdmVycy90dHkvdnQvdnQuYwpAQCAtMzY1Niw3ICszNjU2LDcgQEAgRVhQT1JUX1NZTUJP
TF9HUEwoZG9fdW5yZWdpc3Rlcl9jb25fZHJpdmVyKTsKICAqICAgICB3aGVuIGEgZHJpdmVyIHdh
bnRzIHRvIHRha2Ugb3ZlciBzb21lIGV4aXN0aW5nIGNvbnNvbGVzCiAgKiAgICAgYW5kIGJlY29t
ZSBkZWZhdWx0IGRyaXZlciBmb3IgbmV3bHkgb3BlbmVkIG9uZXMuCiAgKgotICogICAgICB0YWtl
X292ZXJfY29uc29sZSBpcyBiYXNpY2FsbHkgYSByZWdpc3RlciBmb2xsb3dlZCBieSB1bmJpbmQK
KyAqICAgICB0YWtlX292ZXJfY29uc29sZSBpcyBiYXNpY2FsbHkgYSByZWdpc3RlciBmb2xsb3dl
ZCBieSB1bmJpbmQKICAqLwogaW50IGRvX3Rha2Vfb3Zlcl9jb25zb2xlKGNvbnN0IHN0cnVjdCBj
b25zdyAqY3N3LCBpbnQgZmlyc3QsIGludCBsYXN0LCBpbnQgZGVmbHQpCiB7CkBAIC0zNjY2LDcg
KzM2NjYsNyBAQCBpbnQgZG9fdGFrZV9vdmVyX2NvbnNvbGUoY29uc3Qgc3RydWN0IGNvbnN3ICpj
c3csIGludCBmaXJzdCwgaW50IGxhc3QsIGludCBkZWZsdAogICAgICAgIC8qCiAgICAgICAgICog
SWYgd2UgZ2V0IGFuIGJ1c3kgZXJyb3Igd2Ugc3RpbGwgd2FudCB0byBiaW5kIHRoZSBjb25zb2xl
IGRyaXZlcgogICAgICAgICAqIGFuZCByZXR1cm4gc3VjY2VzcywgYXMgd2UgbWF5IGhhdmUgdW5i
b3VuZCB0aGUgY29uc29sZSBkcml2ZXIKLSAgICAgICDCoCogYnV0IG5vdCB1bnJlZ2lzdGVyZWQg
aXQuCisgICAgICAgICogYnV0IG5vdCB1bnJlZ2lzdGVyZWQgaXQuCiAgICAgICAgICovCiAgICAg
ICAgaWYgKGVyciA9PSAtRUJVU1kpCiAgICAgICAgICAgICAgICBlcnIgPSAwOwpAQCAtMzY4Miw3
ICszNjgyLDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwoZG9fdGFrZV9vdmVyX2NvbnNvbGUpOwogICog
ICAgIHdoZW4gYSBkcml2ZXIgd2FudHMgdG8gdGFrZSBvdmVyIHNvbWUgZXhpc3RpbmcgY29uc29s
ZXMKICAqICAgICBhbmQgYmVjb21lIGRlZmF1bHQgZHJpdmVyIGZvciBuZXdseSBvcGVuZWQgb25l
cy4KICAqCi0gKiAgICAgIHRha2Vfb3Zlcl9jb25zb2xlIGlzIGJhc2ljYWxseSBhIHJlZ2lzdGVy
IGZvbGxvd2VkIGJ5IHVuYmluZAorICogICAgIHRha2Vfb3Zlcl9jb25zb2xlIGlzIGJhc2ljYWxs
eSBhIHJlZ2lzdGVyIGZvbGxvd2VkIGJ5IHVuYmluZAogICovCiBpbnQgdGFrZV9vdmVyX2NvbnNv
bGUoY29uc3Qgc3RydWN0IGNvbnN3ICpjc3csIGludCBmaXJzdCwgaW50IGxhc3QsIGludCBkZWZs
dCkKIHsKQEAgLTM2OTIsNyArMzY5Miw3IEBAIGludCB0YWtlX292ZXJfY29uc29sZShjb25zdCBz
dHJ1Y3QgY29uc3cgKmNzdywgaW50IGZpcnN0LCBpbnQgbGFzdCwgaW50IGRlZmx0KQogICAgICAg
IC8qCiAgICAgICAgICogSWYgd2UgZ2V0IGFuIGJ1c3kgZXJyb3Igd2Ugc3RpbGwgd2FudCB0byBi
aW5kIHRoZSBjb25zb2xlIGRyaXZlcgogICAgICAgICAqIGFuZCByZXR1cm4gc3VjY2VzcywgYXMg
d2UgbWF5IGhhdmUgdW5ib3VuZCB0aGUgY29uc29sZSBkcml2ZXIKLSAgICAgICDCoCogYnV0IG5v
dCB1bnJlZ2lzdGVyZWQgaXQuCisgICAgICAgICogYnV0IG5vdCB1bnJlZ2lzdGVyZWQgaXQuCiAg
ICAgICAgICovCiAgICAgICAgaWYgKGVyciA9PSAtRUJVU1kpCiAgICAgICAgICAgICAgICBlcnIg
PSAwOwoK
--047d7b6d88b0eefad504d4f7f9de--
