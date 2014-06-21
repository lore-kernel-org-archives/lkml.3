Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaFULbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 07:31:36 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:39104 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaFULbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 07:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140621115119.8d303c1ada5685c8eb9a1c27@skynet.be>
References: <CADJQGJeBH8RkR2KZpfJX8zxseuFjgpHhV1CiduaCPprz+ncwSQ@mail.gmail.com>
	<20140621115119.8d303c1ada5685c8eb9a1c27@skynet.be>
Date: Sat, 21 Jun 2014 13:31:34 +0200
Message-ID: <CADJQGJf57sxdxiKd-oKba-Ds7Z6BwF4_ofeKeVdNbg26hAozmQ@mail.gmail.com>
Subject: Re: BUG when trying to use deadline iosched in 3.16-rc1
From: Damien Wyart <damien.wyart@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems you're right. I didn't know that parameter could be updated dynamically.
> In that case, adding __init to elv_register was a bad idea because it's no more
> reliable. Could you revert that patch Jens ?

I confirm that reverting locally makes the problem go away.

Damien
