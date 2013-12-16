Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3LPQNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:13:49 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58800 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3LPQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:13:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvx3nvncXYsai_uVdWLp-jAuGWAQCNxGH9R3NvdD1cPFwA@mail.gmail.com>
References: <1387194424-2701-1-git-send-email-lpapp@kde.org>
	<20131216134633.GI18769@lee--X1>
	<CAOMwXhOnHNrzEvf0+QRn6dGb42xR9a33joZcou3ancwSYe36Ug@mail.gmail.com>
	<20131216150937.GO18769@lee--X1>
	<CAOMwXhNJFGiRNB4jnTrzzpSGL8XvaR1Ph_pFrdU+x+guy7Tamg@mail.gmail.com>
	<CAFLxGvx3nvncXYsai_uVdWLp-jAuGWAQCNxGH9R3NvdD1cPFwA@mail.gmail.com>
Date: Mon, 16 Dec 2013 16:13:47 +0000
X-Google-Sender-Auth: T5a4NODKOsoNQK6df_RC0LQ54Ek
Message-ID: <CAOMwXhPLU_2MUkJXgz-ab062bBjtcOEsvwNCSj0vG0eg9sr=rQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for mfd_add_devices
From: Laszlo Papp <lpapp@kde.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 4:05 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Dec 16, 2013 at 4:51 PM, Laszlo Papp <lpapp@kde.org> wrote:
>>>> > The $SUBJECT line is wrong. To see how a subsystem usually formats
>>>> > theirs you must do something like `git log --oneline -- <subsystem>`.
>>>> > And duplicate the format.
>>>> >
>>>> > Commit message?
>>>
>>> These comments are still relevant, please re-post your patch with the
>>> points rectified.
>>
>> I really do not understand how they relevant. "Commit message?" ->
>> What about it? It has a pretty clear commit message. Are you now just
>> picking nits about "foo:" vs "(foo)" in the short line?
>
> The commit message needs to have subject and a body.

Why? What advantage does that have in very simple cases like this?

> A good message body explains what the current situation is, why it is
> broken/has problems
> and how this patch fixes that.

The current commit message explains that in my opinion. Please bring
up real issues with it.
