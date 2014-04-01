Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaDAW4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:56:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60737 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaDAW4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <1396388412-22573-1-git-send-email-andi@firstfloor.org>
References: <1396388412-22573-1-git-send-email-andi@firstfloor.org>
Date: Tue, 1 Apr 2014 15:56:17 -0700
X-Google-Sender-Auth: 5Tqet2bKPPLovsfwKHzarQMKA6w
Message-ID: <CA+55aFwYRGV65DsK4kBcdt-6PP1EY-3dOE=WUOhG=G5hcXYnVg@mail.gmail.com>
Subject: Re: Updated asmlinkage patch v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 2:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Did some basic sanity checks with LTO and everything
> works (still need the three other LTO patches to build)

Ok, this series looks much better. Thanks,

          Linus
