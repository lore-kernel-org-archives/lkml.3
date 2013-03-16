Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3CPQYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:24:12 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33018 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3CPQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAHh0gOinjQvHV4yG+w4Lu+ZJ9ZWS=EgnDjCrFHAwkfquWEPhCg@mail.gmail.com>
References: <1362289927-3635-1-git-send-email-mc74hc00@gmail.com>
	<1362303621.13011.14.camel@mattotaupa>
	<CAHh0gOinjQvHV4yG+w4Lu+ZJ9ZWS=EgnDjCrFHAwkfquWEPhCg@mail.gmail.com>
Date: Sun, 17 Mar 2013 01:24:07 +0900
Message-ID: <CAHh0gOihWm052RAyQV0VJxqxWqq+4Z6YaHFnogBcCzvGzxZ5tQ@mail.gmail.com>
Subject: Re: [PATCH v2] sp5100_tco: Remove code that may cause a boot failure
From: Tanaka Takahisa <mc74hc00@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        Paul Menzel <paulepanter@users.sourceforge.net>
Cc: linux-watchdog@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>,
        Timothy Rundle <tgrundlesr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

I found out the commit of this patch in the linux-next. Thank you for
improving the commit log.
I am sorry for all the trouble I have caused you and Paul.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=84a9a694633692d54c8b969664ce8fd115fa09f9


Best regards,
Takahisa
