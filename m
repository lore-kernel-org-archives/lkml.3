Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaEVXJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:09:52 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:53832 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaEVXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <1400799936-26499-5-git-send-email-keescook@chromium.org>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org> <1400799936-26499-5-git-send-email-keescook@chromium.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 May 2014 16:08:45 -0700
Message-ID: <CALCETrVUfQasAX_JsRZ-HVbMjtxVJT2svwHk9vUOFdoB8H0kjw@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] seccomp: move no_new_privs into seccomp
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:
> Since seccomp transitions between threads requires updates to the
> no_new_privs flag to be atomic, changes must be atomic. This moves the nnp
> flag into the seccomp field as a separate unsigned long for atomic access.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Andy Lutomirski <luto@amacapital.net>
