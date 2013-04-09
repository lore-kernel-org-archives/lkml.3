Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936803Ab3DIPsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:48:14 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:47614 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936173Ab3DIPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:48:12 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXTPe_nT40CG1x9AER+Ctc+zmzFG0YYcpnsXb01_vcWLQ@mail.gmail.com>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
	<20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
	<CA+icZUVk-iLtodZi_46qmk410Ei+tW6RR5kV2fx0N8v6neKTPQ@mail.gmail.com>
	<20130410002311.8a0b0503bcbda151b9de9469@canb.auug.org.au>
	<CA+icZUUboWkL8vHvN6+xk=9kz8SXexxgMN-g+xuPB24T1wTSRw@mail.gmail.com>
	<CA+icZUXTPe_nT40CG1x9AER+Ctc+zmzFG0YYcpnsXb01_vcWLQ@mail.gmail.com>
Date: Tue, 9 Apr 2013 17:48:10 +0200
Message-ID: <CA+icZUXQnNr509wtgO3zto6bkDZOA0hc2EBEyGtwNnwJsEjevw@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=047d7bfd0c2e003dcb04d9ef7b30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bfd0c2e003dcb04d9ef7b30
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2013 at 5:11 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Apr 9, 2013 at 4:32 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote=
:
>> On Tue, Apr 9, 2013 at 4:23 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>>> Hi Sedat,
>>>
>>> On Tue, 9 Apr 2013 16:11:50 +0200 Sedat Dilek <sedat.dilek@gmail.com> w=
rote:
>>>>
>>>> [ CC Al Viro ]
>>>
>>> You forgot to do that ...
>>>
>>>> Is there a "magic" git-command to revert all commits coming from your
>>>> latest vfs-merge (commit c1c04d3667608a630ae0821995b465a523e83fb1)?
>>>>
>>>> 2013-04-09 11:36 Stephen Rothwell   =E2=94=82 M=E2=94=80=E2=94=90 =E2=
=94=82 =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=82         =E2=94=82 =
20130405/vfs
>>>
>>> You would normally do "git revert -m 1 c1c04d366760". However, that doe=
s
>>> not revert cleanly in today's linux-next (due to more patches modifying
>>> the files involved).
>>>
>>
>> Just wanted to improve my git Know-How.
>>
>>>> After reverting all these commits I would like to pull-in latest
>>>> vfs.git#for-next.
>>>
>>> It would probably be easier to wait for tomorrow's linux-next.  Or just
>>> test Al's tree in its own.
>>
>> Doug reported problems on his way "reverting the current vfs stuff"
>> and Al's new tree was reported as OK.
>> A lot of merge-conflicts... that's what I see when trying to pull in
>> Al's tree in today's Linux-Next.
>> So, I better wait for tommorrow.
>>
>> Anyway, a warning in your CHANGELOG is very much appreciated on such
>> KNOWN ISSUES.
>>
>
> vfs-next does break in KVM, cannot say this is due to vfs-related
> changes or other stuff.
> Build-log attached.

[ CC AL Viro (forgot again) ]

With attached patch vfs-next is OK for me.
Also known issue (see [1]) :-).

- Sedat -

[1] https://lkml.org/lkml/2013/4/7/229

> - Sedat -
>
>> Regards,
>> - Sedat -
>>
>>> --
>>> Cheers,
>>> Stephen Rothwell                    sfr@canb.auug.org.au

--047d7bfd0c2e003dcb04d9ef7b30
Content-Type: application/octet-stream; 
	name="0001-vfs-Revert-kvm-changes-in-constify-a-bunch-of-struct.patch"
Content-Disposition: attachment; 
	filename="0001-vfs-Revert-kvm-changes-in-constify-a-bunch-of-struct.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfb8qb2r1

RnJvbSBiMmM5ZTUyNmQ3ZjNhZGY2ZmRlYzVmNjU1YjEyMmU3YTU5MzNmNDJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDkgQXByIDIwMTMgMTc6MzY6MjEgKzAyMDAKU3ViamVjdDogW1BBVENIXSB2ZnM6
IFJldmVydCBrdm0gY2hhbmdlcyBpbiAiY29uc3RpZnkgYSBidW5jaCBvZiBzdHJ1Y3QKIGZpbGVf
b3BlcmF0aW9ucyBpbnN0YW5jZXMiCgpTZWUgY29tbWl0IDlkZjEwMmJlMzFhZjgyYmYxZWRmYzg4
ZmM2YjBhNjk0NjQyMjdiNzEgaW4gdmZzLmdpdCNmb3ItbmV4dC4KClNpZ25lZC1vZmYtYnk6IFNl
ZGF0IERpbGVrIDxzZWRhdC5kaWxla0BnbWFpbC5jb20+Ci0tLQogdmlydC9rdm0va3ZtX21haW4u
YyB8IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFp
bi5jCmluZGV4IDc3YmJiZjEuLmFkYzY4ZmUgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2t2bV9tYWlu
LmMKKysrIGIvdmlydC9rdm0va3ZtX21haW4uYwpAQCAtMTg1NCw3ICsxODU0LDcgQEAgc3RhdGlj
IGludCBrdm1fdmNwdV9yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpm
aWxwKQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9u
cyBrdm1fdmNwdV9mb3BzID0geworc3RhdGljIHN0cnVjdCBmaWxlX29wZXJhdGlvbnMga3ZtX3Zj
cHVfZm9wcyA9IHsKIAkucmVsZWFzZSAgICAgICAgPSBrdm1fdmNwdV9yZWxlYXNlLAogCS51bmxv
Y2tlZF9pb2N0bCA9IGt2bV92Y3B1X2lvY3RsLAogI2lmZGVmIENPTkZJR19DT01QQVQKQEAgLTIz
NzUsNyArMjM3NSw3IEBAIHN0YXRpYyBpbnQga3ZtX3ZtX21tYXAoc3RydWN0IGZpbGUgKmZpbGUs
IHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgY29u
c3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBrdm1fdm1fZm9wcyA9IHsKK3N0YXRpYyBzdHJ1Y3Qg
ZmlsZV9vcGVyYXRpb25zIGt2bV92bV9mb3BzID0gewogCS5yZWxlYXNlICAgICAgICA9IGt2bV92
bV9yZWxlYXNlLAogCS51bmxvY2tlZF9pb2N0bCA9IGt2bV92bV9pb2N0bCwKICNpZmRlZiBDT05G
SUdfQ09NUEFUCkBAIC0yNDczLDcgKzI0NzMsNyBAQCBvdXQ6CiAJcmV0dXJuIHI7CiB9CiAKLXN0
YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGt2bV9jaGFyZGV2X29wcyA9IHsKK3N0
YXRpYyBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGt2bV9jaGFyZGV2X29wcyA9IHsKIAkudW5sb2Nr
ZWRfaW9jdGwgPSBrdm1fZGV2X2lvY3RsLAogCS5jb21wYXRfaW9jdGwgICA9IGt2bV9kZXZfaW9j
dGwsCiAJLmxsc2VlawkJPSBub29wX2xsc2VlaywKLS0gCjEuOC4yCgo=
--047d7bfd0c2e003dcb04d9ef7b30--
