Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbbAYNqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:46:48 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:47911 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbAYNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:46:45 -0500
Message-ID: <54C4F3BE.60600@ahsoftware.de>
Date: Sun, 25 Jan 2015 14:46:38 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigbrady.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] modsign: use shred to overwrite the private key before
 deleting it
References: <54C2F4F8.20809@draigBrady.com>	<1422096327-4483-1-git-send-email-holler@ahsoftware.de>	<54C383E0.9060408@ahsoftware.de>	<54C38B6D.1060806@ahsoftware.de>	<54C3901D.8040406@ahsoftware.de>	<54C45153.2050703@draigBrady.com>	<54C4583A.5040505@ahsoftware.de>	<54C4C65A.2020403@ahsoftware.de>	<54C4CC05.9090602@ahsoftware.de>	<54C4D6BA.4080308@ahsoftware.de> <CAFLxGvzZOfhwW5hp1GDhTHLU5Z=9ozkOQgvatqhwDT982hfYcA@mail.gmail.com> <54C4E080.4020507@ahsoftware.de> <54C4E351.6010601@ahsoftware.de>
In-Reply-To: <54C4E351.6010601@ahsoftware.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.01.2015 um 13:36 schrieb Alexander Holler:
> Am 25.01.2015 um 13:24 schrieb Alexander Holler:
>> Am 25.01.2015 um 13:08 schrieb Richard Weinberger:
>>>
>>> Or add support for the "s" chattr to major filesystems.

(...)

>> So maybe shred should first set the 's' attribute before calling unlink
>> on that file (if it doesn't already do it). I will look at it and send a
>> patch if necessary. It's at least a small bit where I can help. ;)

(...)

That currently looks like a total waste of time. Grepping the kernel for 
SECRM_FL looks like this flags isn't supported (used) by any fs.

Regards,

Alexander Holler
