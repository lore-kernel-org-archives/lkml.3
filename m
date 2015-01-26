Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbbAZVgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:36:00 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58144 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbbAZVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwa1-pudNus+r=5EghpGkm33h--GZNND5UHt=ZKvP15Xw@mail.gmail.com>
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
 <CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
 <CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
 <CA+5PVA5RdtLyRiYerG=u--bRZQ87qU0EGf7kGPMiQs9_KB3hRw@mail.gmail.com> <CA+55aFwa1-pudNus+r=5EghpGkm33h--GZNND5UHt=ZKvP15Xw@mail.gmail.com>
From: Junio C Hamano <gitster@pobox.com>
Date: Mon, 26 Jan 2015 13:35:36 -0800
X-Google-Sender-Auth: gLsGQSpMyIY1gaEUea4rrPhvLrE
Message-ID: <CAPc5daVu=hjjYwDoCwco=cdg16kib80ZBbArh3z8R+j2vq6C6g@mail.gmail.com>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 1:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 26, 2015 at 1:07 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>
>> Or did I miss a way that git-apply can take a git patch and apply it
>> to a tree that isn't a git repo?
>
> Exactly. "git apply" works as a straight "patch" replacement outside
> of a git repository. It doesn't actually need a git tree to work.

What is your take on CVE-2015-1196, which brought this /regression/ to
GNU patch?
If "git apply" get /fixed/ for that same CVE, would that /break/ your fix?
