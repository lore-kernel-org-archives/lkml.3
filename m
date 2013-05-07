Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3EGSlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:41:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3EGSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:41:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/5] ARM: Third batch of arm-soc changes for 3.10, again
Date: Tue, 7 May 2013 20:41:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de> <CA+55aFxJB3OG+-tu2SqAOzn9T7zDb0P9jgbUOMHnXs9m_nXNUA@mail.gmail.com>
In-Reply-To: <CA+55aFxJB3OG+-tu2SqAOzn9T7zDb0P9jgbUOMHnXs9m_nXNUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305072041.37493.arnd@arndb.de>
X-Provags-ID: V02:K0:b0lIMCFSJx+7xBVT1o58kb546Fu0pJmCc3UEg7ug6WF
 hLRifLJ5qlztN6NIE+PfOycBlr4VIi0bSjg3wlXct1t9M5HX1H
 LDxq5SfXP2+GRrX6/IAM55riFMJN/B/u3JlJwQ64xJET7PBzHc
 w0mLLvC4/6ee96jHD1qnHFONwnc/uJ/f88tUjnViDfd2TS26Ri
 Ht4yqD/z/khniumnRdxWam8nNxzRcorozxsHJO3uy93ewvdHCW
 iPJH+7UsQNY8S8S+yZiWAgMgWhr1smNMaxxZ4NQ6YLZWkZ09Z5
 7qeuFz+WgjmEIITRgiIsO4rFUsh4cUSGtCsAGa+9pE5fQfw2jW
 R1DwJlDf8urwYVpF8gfw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 May 2013, Linus Torvalds wrote:
> On Tue, May 7, 2013 at 10:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Here are the same pull requests as before, with numbers and distinct
> > time stamps. I hope I didn't screw up in a different way this time.
> 
> Ok, I notice that you seem to have forgotten the "--summary" flag from
> your diffstat in your new script.
> 
> Not a showstopper, but make sure that the diffstat flags are
> 
>   "git diff -M --stat --summary"
> 
> (And yes, I prefer "-M", not "-C", because while copy information is
> interesting, it tends to hide the fact that the copying added a lot of
> lines, so the "-C" flag ends up not giving as good line add/del
> information, even if the data that something looks like a copy of
> another file is interesting).

Right, another thing that I actually knew and then forgot to do. Olof
has just sent me the script he used the past few times, I'll use that
in the future.

	Arnd
