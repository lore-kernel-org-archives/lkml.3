Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab3CQWJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 18:09:18 -0400
Received: from ac250205.ppp.asahi-net.or.jp ([183.77.250.205]:49849 "EHLO
	smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3CQWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 18:09:16 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Mar 2013 18:09:16 EDT
Date: Mon, 18 Mar 2013 07:02:06 +0900
From: Mattia Dongili <malattia@linux.it>
To: Arthur Wirski <awirski@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sony-laptop: SVS151290S kbd backlight and gfx switch
 support
Message-ID: <20130317220205.GA13240@kamineko.org>
References: <1363548095-3545-1-git-send-email-awirski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363548095-3545-1-git-send-email-awirski@gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.7.0+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 08:21:35PM +0100, Arthur Wirski wrote:
> SVS151290S series uses handle 0x0163 for keyboard backlight and 0x015B for the graphics switch.
> 
> Signed-off-by: Arthur Wirski <awirski@gmail.com>

Acked-by: Mattia Dongili <malattia@linux.it>


Matthew,
could you pick this up for 3.10?

Thanks
-- 
mattia
:wq!
