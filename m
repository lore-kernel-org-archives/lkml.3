Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3JWSNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:13:39 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55321 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3JWSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <52680aa01445165d7@agluck-desk.sc.intel.com>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
	<52680aa01445165d7@agluck-desk.sc.intel.com>
Date: Wed, 23 Oct 2013 11:13:37 -0700
Message-ID: <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 10:42 AM, Luck, Tony <tony.luck@intel.com> wrote:
> Replacement for yesterday's pull request - fixes a build bug when CONFIG_SMP=n
> found by Fengguang's zero-day auto-build robot army.  If you pulled (and pushed)
> that one before finding this in your mailbox - then I can send the one-line
> patch to be applied on top of yesterday's version.

Well - I might as well put the brown paper bag over my head and go sit
in the corner :-(

I accidentally applied an extra patch "UEFI, CPER: Move cper.c to a
more proper place"
that Chen Gong had sent to me internally but has only been mentioned
in concept on the mailing list.

So feel free to pop the 10th patch off and drop it.

-Tony
