Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3IITwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:52:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59266 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3IITwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <522E2487.90109@zytor.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<27562.1378753264@turing-police.cc.vt.edu>
	<522E2487.90109@zytor.com>
Date: Mon, 9 Sep 2013 15:52:48 -0400
Message-ID: <CA+5PVA4mu=ykBMgWYaEagCsDexR-qFYH0tfjK+4B+xOCPonNXg@mail.gmail.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Josh Boyer <jwboyer@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, David Lang <david@lang.hm>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 3:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/09/2013 12:01 PM, Valdis.Kletnieks@vt.edu wrote:
>> On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:
>>
>>> Given that we know that people want signed binaries without
>>> blocking kexec, you should have '1' just enforce module signing
>>> and '2' (or higher) implement a full lockdown including kexec.
>>
>>> Or, eliminate the -1  permanently insecure option and make this a
>>> bitmask, if someone wants to enable every possible lockdown, have
>>> them set it to "all 1's", define the bits only as you need them.
>>
>> This strikes me as much more workable than one big sledgehammer.
>>
>
> I.e. capabilities ;)

Circles.  All I see here are circles.

Having lived an entire release with a capabilities based mechanism for
this in Fedora, please no.

And if you are talking about non-POSIX capabilities as you mentioned
earlier, that seems to be no different than having securelevel being a
bitmask of, well, levels.  I don't have much opinion on securelevel
being a big hammer or a bitmask of finer grained things, but I do
think it's a more manageable way forward.  Calling the implementation
"capabilities" seems to just be unnecessarily confusing.

josh
