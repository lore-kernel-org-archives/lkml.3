Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab3CQWIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 18:08:13 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63696 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3CQWIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 18:08:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130317215812.GA23103@merkur.ravnborg.org>
References: <CANeU7QkMd_evQrJL1Otp3j3CR9FAXSXO9VOKSFmESkWPZNMkEA@mail.gmail.com>
	<20130317215812.GA23103@merkur.ravnborg.org>
Date: Sun, 17 Mar 2013 15:08:11 -0700
X-Google-Sender-Auth: T9hWDftvRrXI9V_TZjKDhStTWV4
Message-ID: <CANeU7Q=uQe7euVnrKExLg0yb1mDJm8NFoFzTqnTn1Gayf69gnA@mail.gmail.com>
Subject: Re: [RFC PATCH] kbuild: avoid some unnecessary rebuild
From: Christopher Li <sparse@chrisli.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec54ee608b137d004d8261b77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54ee608b137d004d8261b77
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Mar 17, 2013 at 2:58 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> We got no patch - just some git help stuff.
> Seems you mistyped somthing..
>

Oops, sorry about that. I reattach the patch here.

Chris

--bcaec54ee608b137d004d8261b77
Content-Type: application/octet-stream; 
	name="kbuild-avoid-rebuild-some-object.patch"
Content-Disposition: attachment; 
	filename="kbuild-avoid-rebuild-some-object.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heer7nq80

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZSBiL2FyY2gveDg2
L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQppbmRleCA4YTg0NTAxLi4xNzA2ZWU1IDEwMDY0NAot
LS0gYS9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUKKysrIGIvYXJjaC94ODYvYm9v
dC9jb21wcmVzc2VkL01ha2VmaWxlCkBAIC0zMyw2ICszMyw3IEBAICQob2JqKS9lZmlfc3R1Yl8k
KEJJVFMpLm86IEtCVUlMRF9DTEZBR1MgKz0gLWZzaG9ydC13Y2hhciAtbW5vLXJlZC16b25lCiAK
IGlmZXEgKCQoQ09ORklHX0VGSV9TVFVCKSwgeSkKIAlWTUxJTlVYX09CSlMgKz0gJChvYmopL2Vi
b290Lm8gJChvYmopL2VmaV9zdHViXyQoQklUUykubworCXRhcmdldHMgKz0gZWJvb3QubyBlZmlf
c3R1Yl8kKEJJVFMpLm8KIGVuZGlmCiAKICQob2JqKS92bWxpbnV4OiAkKFZNTElOVVhfT0JKUykg
Rk9SQ0UKZGlmZiAtLWdpdCBhL3NjcmlwdHMvbW9kL01ha2VmaWxlIGIvc2NyaXB0cy9tb2QvTWFr
ZWZpbGUKaW5kZXggOTQxNWI1Ni4uZTIwZDA2YiAxMDA2NDQKLS0tIGEvc2NyaXB0cy9tb2QvTWFr
ZWZpbGUKKysrIGIvc2NyaXB0cy9tb2QvTWFrZWZpbGUKQEAgLTQ4LDQgKzQ4LDQgQEAgcXVpZXRf
Y21kX2VsZmNvbmZpZyA9IE1LRUxGICAgJEAKICQob2JqKS9lbGZjb25maWcuaDogJChvYmopL2Vt
cHR5Lm8gJChvYmopL21rX2VsZmNvbmZpZyBGT1JDRQogCSQoY2FsbCBpZl9jaGFuZ2VkLGVsZmNv
bmZpZykKIAotdGFyZ2V0cyArPSBlbGZjb25maWcuaAordGFyZ2V0cyArPSBlbGZjb25maWcuaCBk
ZXZpY2V0YWJsZS1vZmZzZXRzLnMK
--bcaec54ee608b137d004d8261b77--
