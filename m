Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3LPRgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:36:31 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41085 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3LPRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
References: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
Date: Mon, 16 Dec 2013 09:36:27 -0800
X-Google-Sender-Auth: 5InE455AZF9MQhwtXhGB1twTfz0
Message-ID: <CAGXu5jKqdHPDXDrh4sMUNd+ihuJHKwSbygVOHET6cDer7VnN=A@mail.gmail.com>
Subject: Re: [Resend] [PATCH 0/2] procfs: make /proc/*/{stack,syscall,pagemap} 0400
From: Kees Cook <keescook@chromium.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 10:57 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> The following patches make /proc/*/{stack,syscall,personality,pagemap}
> 0400.

Yes, please! This greatly reduces the scope of the leak problem (with
0400 the leak is possible only if an attacker can spawn the target
setuid process, instead of being able to leak from an already running
one).

-Kees

-- 
Kees Cook
Chrome OS Security
