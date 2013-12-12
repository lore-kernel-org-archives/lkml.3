Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3LLVZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:25:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51200 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab3LLVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:25:04 -0500
Date: Thu, 12 Dec 2013 22:24:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Brecht Machiels <brecht@mos6581.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 41c7f74 rtc: Disable the alarm in the hardware (v2)
Message-ID: <20131212212454.GC30162@pd.tnic>
References: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org>
 <529CF1D5.6010406@linaro.org>
 <20131202211958.GE7380@pd.tnic>
 <l7ppbg$brg$1@ger.gmane.org>
 <52AA10F4.6070108@linaro.org>
 <52AA27C7.3090206@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52AA27C7.3090206@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 01:16:55PM -0800, John Stultz wrote:
> Borislav: I'd like to add your tested by too, if you've had the
> chance.

Sorry John, I still see you on the todo list but haven't had a chance due to
more pressing issues. :-\

Tell you what: I'll try to find some time over the weekend to reinstall
the box which has the issue and will give it a run. You could go ahead
and commit it but keep it on top of a branch in case it needs to be
reverted. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
