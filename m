Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab3CIRj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 12:39:26 -0500
Received: from mail2.sha-bang.de ([78.47.120.114]:44939 "EHLO mail.sha-bang.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3CIRjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 12:39:25 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Mar 2013 12:39:25 EST
From: Sascha Wilde <wilde@sha-bang.de>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
        Salvatore Sisinni <s.sisinni@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume at 100%
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
Date: Sat, 09 Mar 2013 18:50:54 +0100
Message-ID: <m2vc90798h.fsf@kenny.lan.sha-bang.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi *,

same problem here on my HP Compaq 6910p.

I just tested with vanilla linux 3.8.2 -- unfortunately the problem
still persists.[1][2]  The last (stable) kernel working for me is 3.6.11.

I'll happily provide any additional information which might help getting
this fixed.  Just ask... :)

Please CC me in any response, for I'm not subscribed to lkml.

cheers
sascha

[1]  FWIW, self build vanilla linux 3.8.2 with very generic config on
     Debian Wheezy 64bit.
[2]  FWIW², I'm under the stron impression that the whole fan control
     changed in the latest vanilla kernels on my 6910p even before doing
     a suspend/resume -- it seems to be more "binary" if you will, in
     that the fan is not running at all for a while and then at a 100%
     to return back to 0% after doing some serious cooling.  With 3.6.11
     and older it is more "analogue", with slow fan when only a bit
     cooling is needed.  No idea if this is related to the issue at
     hand.
-- 
Sascha Wilde

If you think technology can solve your problems you don't understand
technology and you don't understand your problems.  (Bruce Schneier)
