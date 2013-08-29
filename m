Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3H2R3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:29:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40067 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab3H2R3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:29:37 -0400
Message-ID: <521F84D4.6060108@zytor.com>
Date: Thu, 29 Aug 2013 10:28:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: dl9pf@gmx.de
CC: linux-kernel@vger.kernel.org, x86@kernel.org, pageexec@freemail.hu,
        llvmlinux@lists.linuxfoundation.org, behanw@converseincode.com
Subject: Re: [PATCH] [RFC] [X86] Fix a compilation issue with clang.
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de>
In-Reply-To: <1377796428-12719-1-git-send-email-dl9pf@gmx.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 10:13 AM, dl9pf@gmx.de wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Clang does not support the "shortcut" we're taking here for gcc (see below).

Read: clang is gratuitously incompatible with gcc.

> The patch extends and uses the macro _ASM_DX to do the job.

You just changed the sematics of the _ASM_* macros... that doesn't seem
like a great idea.  It's probably okay for the registers, but still...

	-hpa

