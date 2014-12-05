Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaLELOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:14:12 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55031 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLELOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:14:10 -0500
Date: Fri, 5 Dec 2014 06:13:56 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard@nod.at>, David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct
 task_struct
Message-ID: <20141205061356.1f3f9015@as>
In-Reply-To: <CALCETrUZhbx-PN8A168khFr6ve_9vdkSiwOcQ-hZbqu4po8hnQ@mail.gmail.com>
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
	<alpine.DEB.2.11.1410291908290.5308@nanos>
	<CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com>
	<20141110.211319.1983610686941713044.davem@davemloft.net>
	<5461EA6B.9020305@nod.at>
	<CALCETrUZhbx-PN8A168khFr6ve_9vdkSiwOcQ-hZbqu4po8hnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should the completely pointless supervisor_stack[] be removed as well?
I had a patch to do that but I never sent it.
