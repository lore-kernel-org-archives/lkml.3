Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3ANFws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:52:48 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53816 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3ANFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:52:47 -0500
Message-ID: <1358142787.28351.1.camel@gitbox>
Subject: Re: [Bulk] [PATCH] timer: vt8500: Move timer code to
 drivers/clocksource
From: Tony Prisk <linux@prisktech.co.nz>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org,
        VT8500 Mailing List 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Date: Mon, 14 Jan 2013 18:53:07 +1300
In-Reply-To: <1358142455.25591.1.camel@gitbox>
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
	 <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
	 <1358140429.25452.1.camel@gitbox> <1358142455.25591.1.camel@gitbox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh grr.. forget this completely. It doesn't take into account the
> patches I already sent for WM8850.
> 
> I guess it needs to be based on timer/cleanup + vt8500/wm8x50.
> 
> Need a little advise on how to handle this one please :)
> 
> Regards
> Tony P

Turns out the original patch applies cleanly on timer/cleanup +
vt8500/wm8x50 anyway so maybe it doesn't need to be rebased.

Let me know if I need to do anything (other than the -m to cleanup the
stats).

Regards
Tony P

