Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaGDHsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:48:03 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42676 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGDHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <CANeU7Q=a82YmUE49uZ1sOxZn0KGLuktSXuj7YsmUb=wXQEpPXA@mail.gmail.com>
References: <CANeU7Q=a82YmUE49uZ1sOxZn0KGLuktSXuj7YsmUb=wXQEpPXA@mail.gmail.com>
Date: Fri, 4 Jul 2014 00:48:00 -0700
X-Google-Sender-Auth: QJvpuzjZzydT3IEpBXQ0hh_8Myg
Message-ID: <CANeU7QmT=vzOGd6bBdkr-kNkt7yfzCWQF5QujiwV7Q8Q9hZw=w@mail.gmail.com>
Subject: Re: [PATCH] sparse: Add CLOG option for saving warning
From: Christopher Li <sparse@chrisli.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linux-Sparse <linux-sparse@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 1:57 AM, Christopher Li <sparse@chrisli.org> wrote:
>
> Add the CLOG=<logname> option in command line to
> save the sparse warning into individual log file.
>
> Typical usage:
>
> make -j8 C=2 CLOG=<logname>

Any feed back for this change? I want to clarify that this patch
is for the Linux kernel kbuild system, not sparse.

Thanks

Chris
