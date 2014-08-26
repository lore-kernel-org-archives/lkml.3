Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbaHZLvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:51:44 -0400
Received: from STOEXHUBFE01.domain01.net ([83.145.59.140]:8705 "EHLO
	stoexhubfe01.domain01.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbaHZLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:51:42 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2014 07:51:42 EDT
Date: Tue, 26 Aug 2014 13:45:51 +0200
From: Anders Darander <anders@chargestorm.se>
CC: <linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>
Message-ID: <20140826114549.GA8332@ad.chargestorm.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-GFI-SMTP-Submission: 1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: yinghai@kernel.org
Cc: 
Bcc: 
Subject: Re: Loading initrd above 4G causes freeze on boot
Reply-To: 
In-Reply-To: <CAE9FiQWOp0pGSXhnaTe62zaFe7QodS6BSCKnC8qamjm3qTRRJA@mail.gmail.com>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: 5AF0 B2E9 78FE 9D75 D110  6F8F 3E31 84D7 920E 938C
X-GPG-Key-Id: 0x920E938C
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: ChargeStorm AB


> Please check if you can apply attached one. That will keep under 2G at
> first, then try any high address.

That patched solved the issue on my Dell XPS 13 9333, that failed to
unpack initrd using 3.17-rc1 and -rc2.

Thus, 
Acked-by: Anders Darander <anders@chargestorm.se>

Cheers,
Anders

-- 
It looks like it's up to me to save our skins.  Get into that garbage chute,
flyboy!
		-- Princess Leia Organa
