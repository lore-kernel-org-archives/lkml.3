Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaA1Mij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:38:39 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37881 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1Mih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:38:37 -0500
MIME-Version: 1.0
X-Originating-IP: [84.208.70.35]
In-Reply-To: <87k3dkzy4t.fsf@rustcorp.com.au>
References: <1390849795-2155-1-git-send-email-teg@jklm.no> <87k3dkzy4t.fsf@rustcorp.com.au>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 28 Jan 2014 13:38:16 +0100
Message-ID: <CAG-2HqXuwcQ_FFaD50QS2AR08yCoDVkdF4WTogBUcH_GYynnVA@mail.gmail.com>
Subject: Re: [RFC][PATCH] module: allow multiple calls to MODULE_DEVICE_TABLE()
 per module
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Jan 28, 2014 at 2:35 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Tom Gundersen <teg@jklm.no> writes:
>> Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
>> second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
>> the modaliases being exposed.
>
> No Signed-off-by?

Sorry about that, I'll resend in a minute with the signoff.

Cheers,

Tom
