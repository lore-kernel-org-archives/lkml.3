Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3BUDMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:12:40 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:34663 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3BUDMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:12:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
References: <20130220.170901.343210063003534302.davem@davemloft.net>
	<CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
Date: Wed, 20 Feb 2013 19:12:37 -0800
X-Google-Sender-Auth: jfymyIs3Ku_iewpLcKn8DTSzcGc
Message-ID: <CA+55aFzuNa9N313pYn+_qS+F7E9mTeWDDjOJhdm0zTZDoZ6XTg@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 7:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Nooo.... You killed the 3c501 and 3c503 drivers! Snif.

.. but thank gods, the 3c509 still exists in the tree. I was worried
for a minute.

          Linus
