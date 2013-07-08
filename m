Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3GHQ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:59:36 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:32945 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3GHQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130708164250.GA12670@kroah.com>
References: <1371926227-2609-1-git-send-email-keescook@chromium.org>
	<1371926227-2609-2-git-send-email-keescook@chromium.org>
	<CAGXu5jKrW4t0HxBiinYTQs9eun_Z+bkNCjKgM_RYaL6Vz1PsoA@mail.gmail.com>
	<20130708164250.GA12670@kroah.com>
Date: Mon, 8 Jul 2013 09:59:34 -0700
X-Google-Sender-Auth: FNC0OzWiikz7ZvH_yG_uCLYNdvY
Message-ID: <CAGXu5jLERGWcXTunTa9oYmwB-58uNB=OwoYpo_xqS=6RNF=1xQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] lkdtm: fix stack protector trigger
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 9:42 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 08, 2013 at 06:09:50AM -0700, Kees Cook wrote:
>> Hi,
>>
>> I'd like to get this series added to lkdtm. Can someone take a moment
>> to review or ack them?
>
> I don't see these in my queue at all, did you copy me the first time
> around on them?

Yup. June 22nd.

> Care to resend them?  Everything is on hold until 3.11-rc1 is out for
> new stuff like this, so you'll have to wait until then at the earliest.

Sure, no problem.

-Kees

--
Kees Cook
Chrome OS Security
