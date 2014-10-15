Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaJOF1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:27:12 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:54408 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaJOF1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:27:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1410150158010.29573@namei.org>
References: <alpine.LRH.2.11.1410150158010.29573@namei.org>
Date: Wed, 15 Oct 2014 07:27:09 +0200
X-Google-Sender-Auth: GmxXRon1TFqNrk7rlOySUJ62SM0
Message-ID: <CA+55aFzOuVhvdDActs=AXr7ZvOkHyH-M2rKVun+Q6R0=r50bvg@mail.gmail.com>
Subject: Re: [GIT PULL] SELinux list corruption fix for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 5:05 PM, James Morris <jmorris@namei.org> wrote:
> This is a fix for list corruption in the SELinux code.
>
> Note that the git-log output is still broken due to the back-merge issue
> previously discussed.  The fix is in commit
> 7c66bdc72bc3d792886c42bbab4b214c1fe536e0

No, the log is correct (the log always is, the back-merges can cause
the trivial *diff* to be broken).

Your branch has way more than that one list corruption fix in it.
Please fix your branch, or fix your description.

            Linus
