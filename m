Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaAWRkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:40:47 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:47877 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaAWRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:40:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140123131936.GK17314@sirena.org.uk>
References: <20140123131936.GK17314@sirena.org.uk>
Date: Thu, 23 Jan 2014 09:40:44 -0800
Message-ID: <CAADWXX-EZm-=cUqR54bWoLyCBo16ErOpAV7DSu5Ne9bhBG532A@mail.gmail.com>
Subject: Re: [GIT PULL] SPI updates for v3.14 remerged
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:19 AM, Mark Brown <broonie@kernel.org> wrote:
>
> spi: Updates for v3.14

gmail hates you. I just found four of your emails in my spam-box.

I don't know why, since it's not the (somewhat) common issue with bad
or missing SPF information. The only thing I can imagine is that gmail
thinks you're not you, since your "From:" line says

   From: Mark Brown <broonie@kernel.org>

but then the SPF is validated as coming from
smtp.mail=broonie@sirena.org.uk with that as a return path:

   Return-Path: <broonie@sirena.org.uk>

so gmail may be dinging you for not using your real "From:". I dunno.
Nothing else looks odd about the email.

               Linus
