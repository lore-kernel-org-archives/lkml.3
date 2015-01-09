Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbbAINoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:44:11 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:55807 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbbAINoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:44:09 -0500
MIME-Version: 1.0
In-Reply-To: <1420810273.32628.2.camel@perches.com>
References: <CAEnQRZDKhgSV=+P_M9aJP-+8DftxVmjgHgAR7OAxFUku6RHsHw@mail.gmail.com>
	<1420810273.32628.2.camel@perches.com>
Date: Fri, 9 Jan 2015 15:37:18 +0200
X-Google-Sender-Auth: 2v4_xGYEK7xnuYA_JMSxCtwUHpk
Message-ID: <CAEnQRZAF=gN_5SPzAdYBaUXQF1WE=1vH3jDHWFC_e+cKvwWy=w@mail.gmail.com>
Subject: Re: checkpatch wrong error message
From: Daniel Baluta <daniel.baluta@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 3:31 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2015-01-09 at 13:57 +0200, Daniel Baluta wrote:
>> Hi Joe,
>>
>> Running ./scripts/checkpatch on the attached [1] patch i get the
>> following error:
>>
>> ERROR: Please use 12 or more chars for the git commit ID like: 'commit
>> 01234567890ab ("commit description")'
>> #6:
>> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
>
> checkpatch uses the same message for multiple forms.
>
> There were some patches around to make this clearer.
> https://lkml.org/lkml/2014/10/20/630
>
> Your commit message does not have quotes around the text.
>
> It should be:
>
> After commit <2b49ccbdd54 ("PM: Kconfig: Set ...")

:) I see, thanks!
