Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaCBDft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 22:35:49 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:62365 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaCBDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 22:35:47 -0500
MIME-Version: 1.0
In-Reply-To: <53123D81.6080003@oracle.com>
References: <52B23CEA.7090405@oracle.com>
	<52CD762B.7020600@oracle.com>
	<53123D81.6080003@oracle.com>
Date: Sat, 1 Mar 2014 21:35:46 -0600
X-Google-Sender-Auth: L0MduuuRD5DwlcDW3bkcyk1xxC0
Message-ID: <CA+55aFxYKbzjSOz6Ui-QcxwN6NuuPM2vnAUw_SxnjzNM9oGcjg@mail.gmail.com>
Subject: Re: fs: gpf in simple_setattr
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 1, 2014 at 2:05 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> ping again?
>
> I've been working on it, but don't see an obvious issue.
>
> It does look like an access to invalid memory easily doable from userspace,
> so it should probably get fixed soon...

It doesn't happen in mainline? Any possibility that you could try to bisect it?

            Linus
