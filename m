Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaIGQuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:50:07 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:43743 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaIGQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <540C1C01.1000308@plexistor.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-5-git-send-email-toshi.kani@hp.com> <CALCETrXjpoVmCi07zo0dKH9LrF+nz9F3GshNiQvmiueFFH=TUQ@mail.gmail.com>
 <1409857025.28990.125.camel@misato.fc.hp.com> <540C1C01.1000308@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 7 Sep 2014 09:49:41 -0700
Message-ID: <CALCETrX-jsDBbPTVBLE=TkrfO9dLJgpog7TVKqi-wxxj6saRjA@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86, mm: Add set_memory_wt() for WT
To: Yigal Korman <yigal@plexistor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        akpm@linuxfoundation.org, Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2014 at 1:49 AM, Yigal Korman <yigal@plexistor.com> wrote:
> I think that what confused Andy (or at least me) is the documentation in Documentation/x86/pat.txt
> If it's possible, can you please update pat.txt as part of the patch?

Indeed.  That file seems to indicate several times that the intended
use of set_memory_xyz is for RAM.

--Andy
