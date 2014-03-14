Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaCNAvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 20:51:00 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58432 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaCNAu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 20:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <53223A4A.7070408@oracle.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<5321CBDA.1060705@oracle.com>
	<CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
	<53222F1A.8090205@oracle.com>
	<CA+55aFxi5VQFu6_MVaVWhwj+bo-orQUmsKRakr_1Txfu1bEcpg@mail.gmail.com>
	<53223A4A.7070408@oracle.com>
Date: Thu, 13 Mar 2014 17:50:58 -0700
X-Google-Sender-Auth: Z_JKFM2upy6RodEWXmr4FhqqV74
Message-ID: <CA+55aFwo=eMtS-HQE_WF1M5qHaNAk5co=xPPWwMbaF+ZRCtghA@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 4:07 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I figured that I'll just read it from System.map (and do the math when
> adding the offset). That should work, right?

Yes, although just reading the symbols from the vmlinux file would be
*much* more convenient, since I know that not everybody saves the
System.map file (cough cough me). But the vmlinux file you need
anyway.

So it would actually be much better to use "nm vmlinux" as the source
of the base information instead, and have just one file you depend on.

              Linus
