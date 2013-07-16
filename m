Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab3GPAxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:53:12 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43414 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3GPAxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:53:10 -0400
MIME-Version: 1.0
In-Reply-To: <1373935603.31535.3.camel@warfang>
References: <20130715154050.GA5941@phenom.dumpdata.com>
	<CA+55aFxShsoiTfXUJM2463ZHPNzBsV_VcKBkM4NyGMpk6Cm=iQ@mail.gmail.com>
	<1373935603.31535.3.camel@warfang>
Date: Mon, 15 Jul 2013 17:53:09 -0700
X-Google-Sender-Auth: OwVGaH0qJdaLMQMPg1-epNzuz1k
Message-ID: <CA+55aFzAg-yU4sX2F8NA0+RZT0v_T3vKc_JrPpX9rXE8-Ofd1A@mail.gmail.com>
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is on/off
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Raymond Jennings <shentino@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 5:46 PM, Raymond Jennings <shentino@gmail.com> wrote:
>
> I'd like to point out that Google Chrome also makes use of CONFIG_ tests
> to detect support for namespaces and pid containers and stuff.

Hmm. It must work fine despite that. Because I run self-compiled
kernels and there are no config files to be found by user apps.
Neither in /proc nor in /boot. And I'm using chrome to write this.

              Linus
