Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab3HTKWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:22:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42053 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3HTKWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:22:13 -0400
Date: Tue, 20 Aug 2013 11:20:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 06/17] ARM: imx: remove custom .init_time hook
Message-ID: <20130820102032.GY23006@n2100.arm.linux.org.uk>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130820072642.GJ31036@pengutronix.de> <52132D6C.2080606@gmail.com> <20130820091000.GK31036@pengutronix.de> <521334C6.4070605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521334C6.4070605@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:20:06AM +0200, Sebastian Hesselbarth wrote:
> Yeah, I am having troubles with linux-arm-kernel rejecting my mails
> because of a suspicious header. I have no clue, what has changed lately
> with my mails sent by git send-email to make them get stuck.

I believe David feels the same way as I do wrt thread hijacking on
mailing lists.  The problem is that it seems all too easy for people
to hit the reply button on some random message from the mailing list,
change the subject line, and then type an entirely new email into the
body not related to the message they hit "reply" on.

So, any message which doesn't look like it's a reply to the preceding
message gets held for moderation.  However, git came along and broke
that - because every patch sent as a threaded reply to a cover email
is effectively a "hijack".  Therefore, there's an exception to this -
if the subject line starts with "[PATCH" then it will be allowed through.

This means if you want to send a RFC, it must be "[PATCH RFC" not just
"[RFC", because "[RFC" isn't whitelisted.  Maybe it should be, but that
is David's decision now.
