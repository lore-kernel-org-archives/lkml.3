Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaISP6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:58:11 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:45017 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaISP6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <541C40AA.4060206@odi.ch>
References: <541AE737.8070009@odi.ch>
	<CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>
	<541C40AA.4060206@odi.ch>
Date: Fri, 19 Sep 2014 11:58:09 -0400
X-Google-Sender-Auth: LjW0KQDSnVclkvRe_iq9aKTYs0c
Message-ID: <CAKb7Uvjm7vFxd-aTtuh4=XE-4JONRJgAt8n93vDHZnARsg+yiw@mail.gmail.com>
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:41 AM, Ortwin Glück <odi@odi.ch> wrote:
>
>
> On 18.09.2014 16:58, Ilia Mirkin wrote:
>> This has been reported a few times already -- probably the same thing
>> as bug https://bugs.freedesktop.org/show_bug.cgi?id=83550
>
> Ah, thanks. I would like to try with that commit reverted, but unfortunately it no longer reverts
> cleanly, and my attempts to make a sensible merge were futile. If you can send me a patch that
> reverts the changes on 3.17-rc5 or 3.16 I am glad to try it out and give you the requested feedback.

git checkout 415f12efc1b2308411b2cbc3e82666b3db8a7758^

[build, confirm it works, grab logs]

git checkout 415f12efc1b2308411b2cbc3e82666b3db8a7758

[build, confirm it's broken, grab logs]

It's not the sort of change that's really revertable...

  -ilia
