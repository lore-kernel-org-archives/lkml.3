Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaI3KkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:40:25 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58282 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaI3KkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:40:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 6/8] asm-generic/io.h: Implement generic {read,write}s*()
Date: Tue, 30 Sep 2014 12:39:37 +0200
Message-ID: <1799506.5Clfp6gmMu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMo8Bf+u8er_KF4nJPSPNf9OmKZHu4y0x3Pcb7DU17y5ocBJqw@mail.gmail.com>
References: <1407925738-26170-1-git-send-email-thierry.reding@gmail.com> <CAMo8BfJ9VJ24zsn_6VwNrAntmDqdJu11O79OyMd8eThv3UaaUw@mail.gmail.com> <CAMo8Bf+u8er_KF4nJPSPNf9OmKZHu4y0x3Pcb7DU17y5ocBJqw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xoTZKFe1vnhcqeEXJlptSzWgVa55K3Na9xPrJxcHH2b
 iKFUUmdrIlC+6UxPjZW/D4N+9nGvgvTX+b2B8PqVuBBkTgZCjf
 1yWn+ti5GP6W5ITzHIfvVBmVaEJyrTN3WdRoLJ3MbAYqgCAhsM
 pfBsqZ/gEBJj7Hlgb3yZUTj7V+JbQ235ddGYk0k/KXBhogEXNc
 2qLxeCVw0nisbeiME2CdjXUoEPYvkV5I6wCCHlhqpO18fgTHgT
 VmGyZkZYaEZ7fUFoDs0YK6cEg7SIyoX9hbTHyxIL/c4vpBtjNn
 6ixbsplmw4dL/MubfxCqj58CysfPhkRxs/wzvpUoJlMc9+t6rj
 obUx9lMEyW9jAa4NHdLQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 14:26:20 Max Filippov wrote:
> On Tue, Sep 30, 2014 at 2:22 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> > Hi Thierry,
> >
> >> I think this can be fixed by including linux/string.h for memset() and
> >> memcpy() in include/asm-generic/io.h.
> >
> > Will you send that fix or do I need to do it?
> 
> Never mind, found that it's fixed in today's next.
> 
> 


Actually I just backed out the original patches, the problem is still
there in my tree.

	Arnd
