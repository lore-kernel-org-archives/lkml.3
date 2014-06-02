Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaFBTBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:01:51 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:48967 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaFBTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <538CC855.4080201@mit.edu>
References: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
	<538CC855.4080201@mit.edu>
Date: Mon, 2 Jun 2014 12:01:49 -0700
X-Google-Sender-Auth: husuJG3vjgXSFsMIfmuXpmV_ldc
Message-ID: <CA+55aFwv+xSrNeZJ_CP7HFxPPKWehZ09uDP3McfzWEEjM00SLg@mail.gmail.com>
Subject: Re: Linux 3.15-rc8 ... and merge window for 3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>, David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 11:54 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> AFAIK, Zebra is still broken on 3.15.  Should something like this be
> applied:
>
> http://article.gmane.org/gmane.linux.kernel.stable/91782

Ahh, yes. I thought it went into the networking tree already, but I'm
not seeing it there. Adding Davem to the cc to see what the situation
is.

               Linus
