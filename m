Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3LTRFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:05:45 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48672 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3LTRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131220170159.GA15634@kroah.com>
References: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
	<1387547475-7135-2-git-send-email-michael.hoefler@studium.uni-erlangen.de>
	<CADKvho6HF9A6agDXwrg7UPcOS0YQh3bPmGzPjOAEO8tZ8cveTw@mail.gmail.com>
	<20131220170159.GA15634@kroah.com>
Date: Fri, 20 Dec 2013 22:35:43 +0530
Message-ID: <CADKvho4s3cQKyrK5jEt6xAoKhfEQ8LZyQnh7tXrY6Kw3V8bPKw@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] silicom: fix whitespace issues in bypass.c
From: Gokulnath A <gokul.linux@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        open list <linux-kernel@vger.kernel.org>,
        Rupert Muchembled <rupert@rmuch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 10:31 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Dec 20, 2013 at 08:36:48PM +0530, Gokulnath A wrote:
>> Hello Michael,
>>
>> On Fri, Dec 20, 2013 at 7:21 PM, Michael Hoefler
>> <michael.hoefler@studium.uni-erlangen.de> wrote:
>> > This patch addresses several problems in bypass.c found by checkpatch.
>> > Furthermore it removes/adds some empty lines to make the code more readable.
>> >
>> > The following problems are fixed:
>> >  - line over 80 characters
>> >  - space after logical operator !
>> >  - spaces instead of tabs
>> >  - missing empty line after local declarations
>> >  - empty line after {
>> >
>>
>> Please do one thing per patch, As Greg suggested for me in previous mail
>> conversations. Here you could have at least 3 or 4 patches.
>> For example, first patch would be a fix for line over 80 characters,
>> followed by the other problems as mentioned above by you.
>
> Nah, all of these are affecting the same macros, so it's ok, I'll take
> it as-is.

ok. Sorry for the comments and thanks for information.

>
> thanks,
>
> greg k-h
