Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab3BUDFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:05:46 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:39900 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3BUDFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:05:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130220.170901.343210063003534302.davem@davemloft.net>
References: <20130220.170901.343210063003534302.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Feb 2013 19:05:24 -0800
X-Google-Sender-Auth: 6WHQ7O2SNiwym__EChYI6OUWc0A
Message-ID: <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 2:09 PM, David Miller <davem@davemloft.net> wrote:
>
> 15) Orphan and delete a bunch of pre-historic networking drivers from
>     Paul Gortmaker.

Nooo.... You killed the 3c501 and 3c503 drivers! Snif.

I wonder if they still worked..

             Linus
