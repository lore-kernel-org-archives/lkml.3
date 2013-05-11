Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3EKWWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 18:22:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61332 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3EKWWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 18:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130511013000.GD14820@jonmason-lab>
References: <20130511013000.GD14820@jonmason-lab>
Date: Sat, 11 May 2013 15:22:52 -0700
X-Google-Sender-Auth: Kv1C1I3gxNjrRDG_09nhQivM4JA
Message-ID: <CA+55aFxkSm34X_cwaQ9chue==SBpFNFfeOYB0dLg8WS1crz1iA@mail.gmail.com>
Subject: Re: [GIT PULL] NTB bug fixes for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 6:30 PM, Jon Mason <jon.mason@intel.com> wrote:
>
>   https://github.com/jonmason/ntb.git for-linus

This has so much wrong that I don't know where to start.

Don't use the https transport unless you have to. Use the "git" one.

Also, that's an unsigned branch from an open hosting site. No. No. No.

If you use github or similar, you need to send me a signed tag, and
your pgp key should in turn be signed by some key I recognize. Not
this kind of "please pull this random branch from this random site"
crap.

                Linus
