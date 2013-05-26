Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3EZRE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 13:04:59 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48136 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754183Ab3EZRE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 13:04:57 -0400
Date: Sun, 26 May 2013 19:04:54 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Dirk Eibach <dirk.eibach@gdsys.cc>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@kernel.crashing.org>, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Make Book E watchdog reset type configurable
Message-ID: <20130526170454.GA8395@spo001.leaseweb.com>
References: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc> <20130502161720.GA7797@roeck-us.net> <429ec64cf7c30a139db40eb20fd3e682@gdsys.cc> <20130503011741.GA23266@roeck-us.net> <7be2cb3417615ff206270a756c6422d6@gdsys.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7be2cb3417615ff206270a756c6422d6@gdsys.cc>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

> having a closer look, I realized booke_wdt is not device-tree based 
> yet. Migrating it would come close to a rewrite, breaking compatibility 
> for all current users. Sorry, this is way beyond the time I have for 
> this project. So I suggest merging the change the way it is, as it is 
> clearly an improvement.

My opinion: don't put it in Kconfig.
I see 2 options for the time being:
1) the DT way
2) introduce a moduleparam for it.

Kind regards,
Wim.

