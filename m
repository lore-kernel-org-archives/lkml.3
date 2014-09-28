Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaI1I4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:56:43 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65099 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaI1I4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140925235322.GW1193@ld-irv-0074>
References: <1409767603-3290-1-git-send-email-computersforpeace@gmail.com>
 <20140908104238.C7B3DC40AB2@trevor.secretlab.ca> <20140925235322.GW1193@ld-irv-0074>
From: Grant Likely <grant.likely@linaro.org>
Date: Sun, 28 Sep 2014 09:56:20 +0100
X-Google-Sender-Auth: nJQobFGlLtSsuE2eC1YzQK0dAGc
Message-ID: <CACxGe6u+R80oMtF5G5GB4mP316wmuHJROAar4mXfL8fjMM407A@mail.gmail.com>
Subject: Re: [PATCH] of: correct of_console_check()'s return value
To: Brian Norris <computersforpeace@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 12:53 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> Hi Grant,
>
> On Mon, Sep 08, 2014 at 11:42:38AM +0100, Grant Likely wrote:
>> On Wed,  3 Sep 2014 11:06:43 -0700, Brian Norris <computersforpeace@gmail.com> wrote:
>> > The comments above of_console_check() say that it will return TRUE if it
>> > registers a preferred console, but add_preferred_console() uses a
>> > 0-equals-success convention, so ths leaves of_console_check() with an
>> > inconsistent policy for its return values.
>> >
>> > Fortunately, nobody was actually checking the return value of
>> > of_console_check(), so this isn't significant at the moment.
>> >
>> > But let's match the comments, so we're doing what we say.
>> >
>> > Fixes: 3482f2c52b77 ('of: Create of_console_check() for selecting a console specified in /chosen')
>> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
>> > Cc: Grant Likely <grant.likely@linaro.org>
>>
>> Good catch. Applied, thanks.
>
> Applied to what? I don't see it in linux-next.

It got merged into mainline on Thursday.

g.
