Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3CPWiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:38:07 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38089 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3CPWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:38:04 -0400
MIME-Version: 1.0
In-Reply-To: <1363469435.1335.137.camel@x61.thuisdomein>
References: <1363469435.1335.137.camel@x61.thuisdomein>
Date: Sat, 16 Mar 2013 15:38:03 -0700
X-Google-Sender-Auth: ZyCd-cZyrYJlhMY-FAIv9Soumx8
Message-ID: <CAGXu5jLfq-AqkTyoZRdcJ-S07h0pFKBXDL=KBi7-nT7NQtftKg@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: stop checking for CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 2:30 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> CONFIG_EXPERIMENTAL has been removed from the tree, in commit
> 3d374d09f16f64ab4d71704cbe621514d36cd0b1 ("final removal of
> CONFIG_EXPERIMENTAL"). There's no need to test for it in checkpatch
> anymore. If it ever pops up again it can be caught when someone feels
> like cleaning up invalid Kconfig symbols and macros again.

Hrm, I actually think it would be better to change this to ERROR
instead of WARN.

-Kees

-- 
Kees Cook
Chrome OS Security
