Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbAIVkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:40:31 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57003 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbAIVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:40:30 -0500
Message-ID: <54B04A50.8040307@vanguardiasur.com.ar>
Date: Fri, 09 Jan 2015 18:38:24 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Fastmap update v2 (pile 1)
References: <1416835236-25185-1-git-send-email-richard@nod.at>
In-Reply-To: <1416835236-25185-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 11/24/2014 10:20 AM, Richard Weinberger wrote:
> Artem,
> 
> as requested I'm resending my fastmap work in smaller pieces.
> This is pile 1 of 7.
> Rebasing my patches to ubifs.git was a massive PITA because the
> logging style changes touched a lot of code and almost every patch
> failed to apply and needed inspection by hand.
> The first patches are bug fixes, the latter introduce cleanups
> and new features.
> After all bugfixes are mainline I'll make sure that all needed
> fixes go into -stable.
> 

Maybe it would be clearer if you could point out exactly which of these
are considered bugfixes.

For bugfixes, having a detailed explanation of the problem the commit is
meant to fix would be better as well.

This patchset seems to have stalled, so perhaps having this information
would help Artem to pick the ones that you point as fixes, before we
miss another cycle.

Would it help if we test the whole series? (any specific test in mind?)

Thanks a lot for the work, it is really appreciated.
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
