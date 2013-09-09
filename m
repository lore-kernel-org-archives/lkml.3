Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3IIUN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:13:59 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:40962 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3IIUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:13:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1309091300420.2479@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<27562.1378753264@turing-police.cc.vt.edu>
	<522E2487.90109@zytor.com>
	<CA+5PVA4mu=ykBMgWYaEagCsDexR-qFYH0tfjK+4B+xOCPonNXg@mail.gmail.com>
	<alpine.DEB.2.02.1309091300420.2479@nftneq.ynat.uz>
Date: Mon, 9 Sep 2013 16:13:56 -0400
Message-ID: <CA+5PVA44KDyQxtmfiyjO323kOOoFo2cbD2pj-GnF1B3fhdms=Q@mail.gmail.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Josh Boyer <jwboyer@gmail.com>
To: David Lang <david@lang.hm>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
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

On Mon, Sep 9, 2013 at 4:10 PM, David Lang <david@lang.hm> wrote:
> On Mon, 9 Sep 2013, Josh Boyer wrote:
>
>> On Mon, Sep 9, 2013 at 3:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> On 09/09/2013 12:01 PM, Valdis.Kletnieks@vt.edu wrote:
>>>>
>>>> On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:
>>>>
>>>>> Given that we know that people want signed binaries without
>>>>> blocking kexec, you should have '1' just enforce module signing
>>>>> and '2' (or higher) implement a full lockdown including kexec.
>>>>
>>>>
>>>>> Or, eliminate the -1  permanently insecure option and make this a
>>>>> bitmask, if someone wants to enable every possible lockdown, have
>>>>> them set it to "all 1's", define the bits only as you need them.
>>>>
>>>>
>>>> This strikes me as much more workable than one big sledgehammer.
>>>>
>>>
>>> I.e. capabilities ;)
>>
>>
>> Circles.  All I see here are circles.
>
>
> the thing is that these are not circles. they are separate orthoginal things
> that you may or may not want to allow.
>
> If this was a simple set of circles, then this could be defined as a vector
> instead of bitmap, the further you go the more secure you are.

I didn't mean your recommendation of using a bitmask.  I understood
your proposal and I don't even disagree with it really.  I was
replying to something else.

josh
