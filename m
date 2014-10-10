Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaJJXrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:47:51 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:43143 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaJJXrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <1412981721-3432-1-git-send-email-prarit@redhat.com>
References: <1412981721-3432-1-git-send-email-prarit@redhat.com>
Date: Fri, 10 Oct 2014 17:47:47 -0600
Message-ID: <CAKocOOPqeXyzVGztAdAcnBW1gihi8HYAefFJ9k=qT6m-oOPzgQ@mail.gmail.com>
Subject: Re: [PATCH] x86, kexec: Add .gitignore file
From: Shuah Khan <shuahkhan@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 4:55 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> When doing git-status there are two untracked files:
>
> \# Untracked files:
> \#   (use "git add <file>..." to include in what will be committed)
> \#
> \#       arch/x86/purgatory/kexec-purgatory.c
> \#       arch/x86/purgatory/purgatory.ro
>
> Add a .gitignore to block these files.

I sent patch for this couple of weeks ago. It is pulled in looks like,
I got tipbot
for that patch.

http://marc.info/?l=linux-kernel&m=141201613309178

-- Shuah
