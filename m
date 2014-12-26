Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaLZRJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:09:55 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37242 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaLZRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:09:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141226142946.GA28213@newt.localdomain>
References: <1419597539-21254-1-git-send-email-kuleshovmail@gmail.com>
	<20141226142946.GA28213@newt.localdomain>
Date: Fri, 26 Dec 2014 23:09:53 +0600
Message-ID: <CANCZXo5wQhsxAbHypZqzaWPiakr9Mjbn-JCw+7+vW8vnmM2y9w@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix multiple coding style issues
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Alexander Kuleshov <kuleshovmail@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeremiah,

Thank you for feedback. It is my first patches to kernel, so i have a
some little questions:

> Jeremiah Mahler <jmmahler@gmail.com>:
> Alexander,
>
> On Fri, Dec 26, 2014 at 06:38:59PM +0600, Alexander Kuleshov wrote:
>
> Your description needs to be more specific than just "coding style
> fixes".  What type of problems did you fix?  How did you find them?
>

There are some lines which more than 80 chars, I found it with
scripts/checkpatch.pl.
What is the best place to put this description? In commit message
after first line?

> Jeremiah Mahler <jmmahler@gmail.com>:
> If you are looking for things to fix I suggest looking in the
> drivers/staging directory.  There are lots of things that need to be
> fixed in there.

So i must make this patch for kernel/git/gregkh/staging.git and resend
it again or just to add to this thread?
Or i'm wrong?

Thank you.
