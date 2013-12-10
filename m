Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab3LJVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:38:29 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59345 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LJVi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:38:27 -0500
MIME-Version: 1.0
In-Reply-To: <1386707123.23829.23.camel@flatline.rdu.redhat.com>
References: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>
	<1386707123.23829.23.camel@flatline.rdu.redhat.com>
Date: Tue, 10 Dec 2013 16:38:27 -0500
X-Google-Sender-Auth: 9mjPx-yK5moEVI9n1nIyY_xy_54
Message-ID: <CA+5PVA4OTOC3nR5vQp3M8J12gn42_rLxxPB-whhPdgPrOVNZMg@mail.gmail.com>
Subject: Re: SELinux change in 3.13 causes sync hang
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Eric Paris <eparis@redhat.com>
Cc: Anand Avati <avati@redhat.com>, James Morris <jmorris@namei.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 3:25 PM, Eric Paris <eparis@redhat.com> wrote:
> I still believe (assuming Josh says it tests ok) that a revert is a
> reasonable fix until next window.  But I might know the actual problem:

Sorry for the delay.  Hit something else post-rc3 that causes my
machine to not boot.

3.13-rc3 exhibits the problem as expected.  The commit reverts cleanly
on top of -rc3 and the resulting kernel doesn't have the issue.

josh
