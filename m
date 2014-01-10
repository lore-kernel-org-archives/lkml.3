Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaAJS4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:56:54 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36173 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAJS4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:56:51 -0500
MIME-Version: 1.0
In-Reply-To: <310861389366000@web24m.yandex.ru>
References: <223151389311706@web9g.yandex.ru> <52CF6129.4040308@amacapital.net>
 <310861389366000@web24m.yandex.ru>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 10 Jan 2014 10:56:29 -0800
Message-ID: <CALCETrX=UOZSMb93sPpC+K6iYMkCuoYve=_m3Ho9WPTp3Qhj7w@mail.gmail.com>
Subject: Re: [RFC] subreaper mode 2 (Re: A feature suggestion for sandboxing processes)
To: Victor Porton <porton@narod.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 7:00 AM, Victor Porton <porton@narod.ru> wrote:
> I don't quite understand your subreaper mode 2, but for me it looks like that this would break compatibility (sandboxed applications ideally should not be written in any special way, any application which does not open new files (or does similar things) should work in sandbox just like as if there would be no sandbox).

I'm suggesting that *sandbox*, not the application in the sandbox, use
subreaper mode 2 (or whatever the new mechanism).  The sandboxed app
should case, except insofar as as the sandbox can't double-fork to
create long-lived subprocesses.

--Andy
