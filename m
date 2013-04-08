Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab3DHVek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:34:40 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:40296 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936109Ab3DHVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:34:38 -0400
MIME-Version: 1.0
In-Reply-To: <1256775981.281402.1364864751771.JavaMail.root@redhat.com>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
	<CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
	<1361998001.2110.22.camel@localhost>
	<20130227221954.GJ2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
	<20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
	<20130322221444.GJ15821@hansolo.jdub.homelinux.org>
	<CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
	<1256775981.281402.1364864751771.JavaMail.root@redhat.com>
Date: Mon, 8 Apr 2013 14:34:38 -0700
X-Google-Sender-Auth: DwBVaE9IHaXoTA2s3mTccDt6OZ4
Message-ID: <CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 6:05 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> ----- Original Message -----
>> From: "Kees Cook" <keescook@chromium.org>
>> To: "Josh Boyer" <jwboyer@redhat.com>
>> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Eric Paris" <eparis@redhat.com>, "Linus Torvalds"
>> <torvalds@linux-foundation.org>, "Christian Kujau" <lists@nerdbynature.de>, "# 3.4.x" <stable@vger.kernel.org>,
>> "LKML" <linux-kernel@vger.kernel.org>
>> Sent: Monday, April 1, 2013 7:51:57 PM
>> Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
>>
>> On Fri, Mar 22, 2013 at 3:14 PM, Josh Boyer <jwboyer@redhat.com> wrote:
>> > On Fri, Mar 22, 2013 at 02:54:48PM -0700, Andrew Morton wrote:
>> >>
>> >> poke.  Nothing got applied.  I'll drop
>> >> kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch, see if that has any
>> >> effect ;)
>> >
>> > Oh dear.
>> >
>> > Eric, were you going to cleanup your suggestion and send it out?
>>
>> Ping? What state is this in?
>
> If Eric doesn't send a patch tomorrow, I will.  Fedora is carrying my
> original patch, but I'd rather get this fixed everywhere.

Pinging again here. Any news on this?

-Kees

--
Kees Cook
Chrome OS Security
