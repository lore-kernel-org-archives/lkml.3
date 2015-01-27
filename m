Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbbA0MJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:09:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55781 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbbA0MJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:09:08 -0500
Date: Tue, 27 Jan 2015 13:08:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127120855.GA9254@pd.tnic>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
 <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
 <54C77E69.7050600@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C77E69.7050600@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 01:02:49PM +0100, Alexander Holler wrote:
> Look at the source at the message which is printed just before and decide
> which one you find more informational / useful.

I find such a message absolutely useless. Also, if it flies off and
printk buffer gets overwritten, it serves you sh*t. IOW, listen to what
Richard tells you.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
