Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3ETScA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:32:00 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:58855 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab3ETSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <519A6BC7.7060902@linux.intel.com>
References: <20130514160108.GA5055@dhcp22.suse.cz>
	<1369062192-7066-1-git-send-email-mhocko@suse.cz>
	<519A483F.7070400@zytor.com>
	<20130520164335.GA9441@dhcp22.suse.cz>
	<CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
	<20130520182306.GA5348@dhcp22.suse.cz>
	<519A6BC7.7060902@linux.intel.com>
Date: Mon, 20 May 2013 11:31:56 -0700
X-Google-Sender-Auth: bVqxyDCc1fzrMQiLn3Wde6KQnhk
Message-ID: <CA+55aFzEm3=2u68_hiQc269NDXCXct7=29EaiBbmVi+-0x7zMA@mail.gmail.com>
Subject: Re: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX
 capable hardware"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?Q?Fernando_Luis_V=C3=A1zquez_Cao?= <fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:30 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> I'll write it up and send a pull request to Linus.

I'm already doing it.

          Linus
