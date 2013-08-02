Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3HBVYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:24:11 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:58610 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3HBVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:24:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com>
References: <20130802181740.GA27100@google.com>
	<CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com>
Date: Fri, 2 Aug 2013 14:24:07 -0700
X-Google-Sender-Auth: otzQodSGzPd78IukbgYYEr8aKoc
Message-ID: <CA+55aFyf_TsUewZ=Fbf418=3-rOTOBmkQDskVY5FN9SbVyV9qg@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for v3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Michal Marek <mmarek@suse.cz>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 1:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Michal? I haven't pushed things out yet (and that allmodconfig build
> from scratch will take 20 min or so), but you can recreate my tree by
> pulling that pci thing locally from:

Yeah, it looks like if you start with an allmodconfig build from
before that pull, and then re-do "make allmodconfig" after the pull
without cleaning the build tree you get that warning.

[ Music from "Jaws" ]

Scary.

             Linus
