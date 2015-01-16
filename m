Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbbAPEw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:52:59 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51828 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbbAPEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:52:58 -0500
MIME-Version: 1.0
In-Reply-To: <20150115181032.GD30960@localhost>
References: <1421161778-5671-1-git-send-email-md.jamalmohiuddin@gmail.com>
	<CACRpkdb2=YyVtFFMqMQrWCVFhtnBOdmw57W0tktYn1c2fS8uQw@mail.gmail.com>
	<20150115181032.GD30960@localhost>
Date: Fri, 16 Jan 2015 10:22:56 +0530
Message-ID: <CAP8vtK+vHR_7h_SYWfBNDZkAqUbtEdSDqw+AteZWGqoY37tYTQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-dln2: Added a Blank line after declaration
From: Jamal Mohammad <md.jamalmohiuddin@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you are write ... checkpatch.pl was giving the error at the
line so i added a blank line... i will send an updated patch..

On Thu, Jan 15, 2015 at 11:40 PM, Johan Hovold <johan@kernel.org> wrote:
> On Thu, Jan 15, 2015 at 06:20:43PM +0100, Linus Walleij wrote:
>> On Tue, Jan 13, 2015 at 4:09 PM, Mohammad Jamal
>> <md.jamalmohiuddin@gmail.com> wrote:
>>
>> > Fix the coding style issue by adding a blank line after declaration
>> >
>> > Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
>>
>> Patch applied.
>
> This one looks bogus; it's adding a random newline within the
> declarations not after.
>
> Johan
