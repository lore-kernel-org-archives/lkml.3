Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaLFDKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 22:10:18 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37781 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLFDKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 22:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJYw+x=YU5O1k=isuxx6gKRP4zQYj03tZYx6mLW0qLPfw@mail.gmail.com>
References: <CAE8gLhn9wFBLvdxTonD5m8Q_wYG_eg_TQOuZnEFPEVXstHdbvw@mail.gmail.com>
	<CAE8gLhkBUWrXsRxBDTpj1sNVKZLe7aVeqMuJArW2ACOkvpR-OQ@mail.gmail.com>
	<CAGXu5jJYw+x=YU5O1k=isuxx6gKRP4zQYj03tZYx6mLW0qLPfw@mail.gmail.com>
Date: Sat, 6 Dec 2014 04:10:15 +0100
Message-ID: <CAE8gLhmxEoJ-7vs+avCite=zWZkVF9t8Y1c8yTu887aFYULRiA@mail.gmail.com>
Subject: Re: PROBLEM: [Launchpad #1396889] [Lenovo ThinkPad T400] kexec reboot fails
From: MegaBrutal <megabrutal@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-01 23:59 GMT+01:00 Kees Cook <keescook@chromium.org>:
>
> I suspect you're encountering a subset of the same problems as
> described in this thread:
> https://lkml.org/lkml/2014/9/30/90
>
> If you can test those patches, that may help demonstrate their utility.
>
> Thanks!

Bang ji le! It works with the patch you linked, xiexie!
I suggest it to be merged into mainline.

Anyway, is there a way to get sure that KASLR actually works now?
(I.e. how do I know if the kernel is really loaded to a random
address?)
Do you have any idea what might be different with my ThinkPad T400
that it is the only one of my machines affected?
