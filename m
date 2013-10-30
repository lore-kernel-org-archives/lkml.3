Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3J3Oab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:30:31 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49984 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3J3Oa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:30:29 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <CAG-2HqUhZdYgYcDGJaFUJV-AqgbbFh55HMcw6nRppiUyeHGjcw@mail.gmail.com>
References: <20130903193547.GA8150@srcf.ucam.org> <1378286856-6384-1-git-send-email-teg@jklm.no>
 <CAG-2HqUhZdYgYcDGJaFUJV-AqgbbFh55HMcw6nRppiUyeHGjcw@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 30 Oct 2013 15:30:07 +0100
Message-ID: <CAG-2HqWKCcFcaWFnLz96YZa=G5mYJg0dMk54jZ7FyNkK-m=PKA@mail.gmail.com>
Subject: Re: [PATCH] input: i8042 - add PNP modaliases
To: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Gundersen <teg@jklm.no>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 2:26 PM, Tom Gundersen <teg@jklm.no> wrote:
> On Wed, Sep 4, 2013 at 11:27 AM, Tom Gundersen <teg@jklm.no> wrote:
>> This allows the module to be autoloaded in the common case.
>>
>> In order to work on non-PnP systems the module should be compiled in or loaded
>> unconditionally at boot (c.f. modules-load.d(5)), as before.
>>
>> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>> --
>
>
> Hi Dmitry,
>
> Any comments on this? Any chance of having this (and the two patches
> dropping EXPERT=y requirements) included for 3.13 (or even 3.12 if it
> is not too late for this kind of stuff)? Let me know if I should
> resend the three patches.

Ping? Any chance of seeing this in 3.13?

Cheers,

Tom
