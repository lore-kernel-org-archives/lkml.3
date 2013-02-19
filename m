Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3BSL74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:59:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51786 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab3BSL7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:59:55 -0500
Date: Tue, 19 Feb 2013 12:59:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] param, charp: Cache val length
Message-ID: <20130219115951.GB26623@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1361178750-17915-1-git-send-email-bp@alien8.de>
 <87txp9j255.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87txp9j255.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 09:54:22PM +1030, Rusty Russell wrote:
> I'm delighted with your enthusiasm for making trivial changes,

Who says I'm enthusiastic about it?

> but I have trouble sharing in it.

I just assumed that noodling for a second time over a string of possible
length of 1024 chars (I know, I know, we will never have params of that
length, yadda yadda...) should be avoided.

Nevermind.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
