Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbbARPrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:47:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40373 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbbARPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:47:32 -0500
Message-Id: <1421596051.2712080.215378161.2B6E3912@webmail.messagingengine.com>
X-Sasl-Enc: qxQk/a78QmbtEJd2Od4Ty1EgScwmmJKsc43pDr/RxTIq 1421596051
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-46f3f2c7
Subject: Re: [PATCHv2 0/4] x86, entry: some cleanup and simplification...
Date: Sun, 18 Jan 2015 16:47:31 +0100
In-Reply-To: <20150118120503.GA3424@pd.tnic>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
 <20150118120503.GA3424@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015, at 13:05, Borislav Petkov wrote:
> Hi,
> 
> btw, you might wanna sync with Denys who's doing cleanups in that area too:
> 
> https://lkml.kernel.org/r/1421272101-16847-1-git-send-email-dvlasenk@redhat.com
> 
> and touching some of the stuff you're changing too.

Thanks. FWIW, the change touches the same area in code, but is orthogonal in concept.

Greetings,
    Alexander 

> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> ECO tip #101: Trim your mails when you reply.
> --
