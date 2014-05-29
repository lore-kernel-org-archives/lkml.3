Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaE2VFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:05:34 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:56383 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaE2VFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140529080320.10062.15946@quantum>
References: <20140529080320.10062.15946@quantum>
Date: Thu, 29 May 2014 14:05:32 -0700
X-Google-Sender-Auth: Qyg5q2BdukYh7FonSvKBQym0Blg
Message-ID: <CA+55aFzHvp9=7gZFfV8qeGrzJfvKzY4OspWbMtvnhwt2Xcas6g@mail.gmail.com>
Subject: Re: [GIT PULL] clk: fixes for 3.15, part 2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 1:03 AM, Mike Turquette <mturquette@linaro.org> wrote:
>
> Small number of user-visible regression fixes for clock drivers. There
> is a memory leak fix for an ST platform, an infinite Loop Of Doom fix
> for the recent changes to the basic clock divider (hopefully the last
> fix for those recent changes) and some Tegra PLL changes which keep PCI
> from being hosed on that platform.

Hmm. I've pulled, but note that the key this is signed with (pgp
fingerprint C325A4D4) doesn't seem to exist on the usual key servers.

Have you changed your key and forgotten to send out the new one? You
*used* to use key ID 5A7C9849..

I've pulled, but as a result of the lacking key I want to verify this
pull request explicitly.

              Linus
