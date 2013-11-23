Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3KWTWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:22:46 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60997 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3KWTWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:22:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131122175445.GA31456@redhat.com>
References: <20131122175424.GA31432@redhat.com>
	<20131122175445.GA31456@redhat.com>
Date: Sat, 23 Nov 2013 11:22:40 -0800
X-Google-Sender-Auth: 7ECzitLNbOXKT_LeJyM6wimv5kA
Message-ID: <CAGXu5jJtPLjv=EsEuYV77g_FbKgD8BC+GbD-Rm-tvaCiVRP4WQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] exec: move the final allow_write_access/fput into free_bprm()
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 9:54 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Both success/failure paths cleanup bprm->file, we can move this
> code into free_bprm() to simlify and cleanup this logic.

Nice, yeah, this looks right.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
