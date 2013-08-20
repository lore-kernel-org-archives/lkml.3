Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3HTKhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:37:24 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:62409 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3HTKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:37:23 -0400
Message-ID: <521346DE.9080600@gmail.com>
Date: Tue, 20 Aug 2013 12:37:18 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 06/17] ARM: imx: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130820072642.GJ31036@pengutronix.de> <52132D6C.2080606@gmail.com> <20130820091000.GK31036@pengutronix.de> <521334C6.4070605@gmail.com> <20130820102032.GY23006@n2100.arm.linux.org.uk>
In-Reply-To: <20130820102032.GY23006@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/13 12:20, Russell King - ARM Linux wrote:
> On Tue, Aug 20, 2013 at 11:20:06AM +0200, Sebastian Hesselbarth wrote:
>> Yeah, I am having troubles with linux-arm-kernel rejecting my mails
>> because of a suspicious header. I have no clue, what has changed lately
>> with my mails sent by git send-email to make them get stuck.
>
> I believe David feels the same way as I do wrt thread hijacking on
> mailing lists.  The problem is that it seems all too easy for people
> to hit the reply button on some random message from the mailing list,
> change the subject line, and then type an entirely new email into the
> body not related to the message they hit "reply" on.
>
> So, any message which doesn't look like it's a reply to the preceding
> message gets held for moderation.  However, git came along and broke
> that - because every patch sent as a threaded reply to a cover email
> is effectively a "hijack".  Therefore, there's an exception to this -
> if the subject line starts with "[PATCH" then it will be allowed through.
>
> This means if you want to send a RFC, it must be "[PATCH RFC" not just
> "[RFC", because "[RFC" isn't whitelisted.  Maybe it should be, but that
> is David's decision now.

Russell,

I already guessed it has something to do with the In-reply-to line, as
only the patches but not the cover letter gets stuck. Thanks for
pointing me at the missing PATCH prefix and sorry for the noise on
the moderators screen.

For me it is fine not to expand the whitelist and after reading
SubmittingPatches again, it clearly says that RFC is just a tag to be
added after PATCH.

Sebastian

