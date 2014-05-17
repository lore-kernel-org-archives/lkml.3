Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaEQNV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:21:59 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61519 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbaEQNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140515224327.GA16255@mwanda>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140515224327.GA16255@mwanda>
Date: Sat, 17 May 2014 15:21:56 +0200
Message-ID: <CAFo99gYEf6GrAjuWNc5+DEEuBV82eejRuy7QtiJuLD+sRccLRA@mail.gmail.com>
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masood Mehmood <ody.guru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11c30814157d6704f9986a89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c30814157d6704f9986a89
Content-Type: text/plain; charset=UTF-8

Okay, everyone agrees with Dan..?

I have made a new patch, which does not check if hnode is NULL.



Best regards
Rickard Strandqvist


2014-05-16 0:43 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, May 15, 2014 at 11:53:53PM +0200, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>
> None of the callers pass in a NULL hnode so there isn't actually a NULL
> dereference here.  You could just remove the check.
>
> regards,
> dan carpenter
>

--001a11c30814157d6704f9986a89
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-Fix-for-possible-null-pointer-dereferenc.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-for-possible-null-pointer-dereferenc.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvay1z6d0

RnJvbSA1OTg2NTkzZjQ5MDQ0ZjFjNGZhZWYwOWIxZTRkYjNlZDhlYzU1N2QzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSaWNrYXJkIFN0cmFuZHF2aXN0IDxyaWNrYXJkX3N0cmFuZHF2
aXN0QHNwZWN0cnVtZGlnaXRhbC5zZT4KRGF0ZTogU3VuLCAxMSBNYXkgMjAxNCAxODo1MTo0MiAr
MDIwMApTdWJqZWN0OiBbUEFUQ0hdIHN0YWdpbmc6IHRpZHNwcmlkZ2U6IG5vZGUuYzogZml4IGZv
ciBwb3NzaWJsZSBudWxsIHBvaW50ZXIgZGVyZWZlcmVuY2UKClJlbW92ZGUgdW5uZWNlc3Nhcnkg
Y2hlY2sgZm9yIG51bGwgcG9pbnRlci4KCldhcyBsYXJnZWx5IGZvdW5kIGJ5IHVzaW5nIGEgc3Rh
dGljIGNvZGUgYW5hbHlzaXMgcHJvZ3JhbSBjYWxsZWQgY3BwY2hlY2suCgpTaWduZWQtb2ZmLWJ5
OiBSaWNrYXJkIFN0cmFuZHF2aXN0IDxyaWNrYXJkX3N0cmFuZHF2aXN0QHNwZWN0cnVtZGlnaXRh
bC5zZT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvdGlkc3BicmlkZ2Uvcm1nci9ub2RlLmMgfCAgICAy
IC0tCiAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvdGlkc3BicmlkZ2Uvcm1nci9ub2RlLmMgYi9kcml2ZXJzL3N0YWdpbmcvdGlkc3Bi
cmlkZ2Uvcm1nci9ub2RlLmMKaW5kZXggOWQzMDQ0YS4uZDkxOGY3ZiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3RpZHNwYnJpZGdlL3JtZ3Ivbm9kZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy90aWRzcGJyaWRnZS9ybWdyL25vZGUuYwpAQCAtMjM2NSw4ICsyMzY1LDYgQEAgc3RhdGljIHZv
aWQgZGVsZXRlX25vZGUoc3RydWN0IG5vZGVfb2JqZWN0ICpobm9kZSwKIAkgICAgKHN0cnVjdCBw
cm9jX29iamVjdCAqKWhub2RlLT5wcm9jZXNzb3I7CiAjZW5kaWYKIAlpbnQgc3RhdHVzOwotCWlm
ICghaG5vZGUpCi0JCWdvdG8gZnVuY19lbmQ7CiAJaG5vZGVfbWdyID0gaG5vZGUtPm5vZGVfbWdy
OwogCWlmICghaG5vZGVfbWdyKQogCQlnb3RvIGZ1bmNfZW5kOwotLSAKMS43LjEwLjQKCg==
--001a11c30814157d6704f9986a89--
