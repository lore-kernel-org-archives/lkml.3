Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355Ab3DKV21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:28:27 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52358 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935234Ab3DKV2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <5167229E.305@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<5167229E.305@zytor.com>
Date: Thu, 11 Apr 2013 14:28:24 -0700
X-Google-Sender-Auth: AuU4HSWW0iFY7kiqTKUsAo2-rrU
Message-ID: <CAGXu5j+jFKcs=SREzc0q5fbCW0U9ugEP1x0LdfnENkms92jdfg@mail.gmail.com>
Subject: Re: [PATCH 0/3] kernel ASLR
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 1:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I am going to set up a tip:x86/kaslr branch, but this patchset really
> needs some work before committing it, in particular Ingo is right that
> it needs to be more finegrained.

Absolutely. I'm working on this currently. Thanks!

-Kees

--
Kees Cook
Chrome OS Security
