Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab3KLXTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:19:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543Ab3KLXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:19:31 -0500
Date: Wed, 13 Nov 2013 00:19:03 +0100
From: Borislav Petkov <bp@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, trenn@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don' t
 treat a missing firmware file as an error
Message-ID: <20131112231903.GN12854@pd.tnic>
References: <1384274383-43510-1-git-send-email-trenn@suse.de>
 <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org>
 <20131112224511.GJ12854@pd.tnic>
 <20131112230138.GL12854@pd.tnic>
 <20131112231008.GC30674@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112231008.GC30674@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 12:10:08AM +0100, Ingo Molnar wrote:
> Hm, that's really weird, I've been using <stable@kernel.org> for years
> and the commits do get picked up. I also never saw such a mailer
> failure.
>
> In any case I've changed my pre-cooked alias to
> <stable@vger.kernel.org>, but still I'm wondering why
> <stable@kernel.org> seems to be working in practice - maybe Greg
> is picking up such commits as well, not via an email flow but via
> scripting?

I believe I read somewhere him saying that he does. But the
stable@kernel.org thing as an email address doesn't work. I'd guess he
greps commit messages for "stable@" or so...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
