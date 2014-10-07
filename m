Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaJGN4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:56:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaJGN4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:56:05 -0400
Message-ID: <5433F0EB.9070207@nod.at>
Date: Tue, 07 Oct 2014 15:55:55 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedeking1@gmail.com
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org> <5427C45C.2080506@nod.at> <5427CB6E.7010007@codeaurora.org> <5427CCD8.2090605@nod.at> <5427E6FE.3090906@codeaurora.org> <5427E8CA.8000904@nod.at> <542D49FD.7040204@codeaurora.org> <542D5203.2080601@nod.at> <542D5657.3060208@codeaurora.org>
In-Reply-To: <542D5657.3060208@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.10.2014 15:42, schrieb Tanya Brokhman:
> How do you test all of your fastmap fixes? Some of them are not easy to reproduce (the pq saving for example). Besides heavy stability testing, I was testing my changes manually by
> a lot of dbg prints in the code and analyzing the logs manually. Not the optimal way....

I'm currently implementing a test framework for fastmap.
Using it I've found many issues.
I hope I can release it soon, but first some legal issues have to be resolved.

Thanks,
//richard
