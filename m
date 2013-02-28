Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3B1XNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:13:07 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38931 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3B1XNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:13:04 -0500
Message-ID: <512FE47C.907@hp.com>
Date: Thu, 28 Feb 2013 18:13:00 -0500
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com> <20130221233818.GM26694@dastard> <m2bobdxl1i.fsf@firstfloor.org> <5126F067.4040707@hp.com> <20130222230048.GP26694@dastard> <20130223001332.GA30494@two.firstfloor.org> <512FC071.3050409@hp.com>
In-Reply-To: <512FC071.3050409@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 03:39 PM, Waiman Long wrote:
>
> activity level. Most of the d_path() call last for about 1ms. There
> are a couple of those that last for more than 10ms.
>

A correction. The time unit here should be us, not ms. Sorry for the 
mistake.

-Longman
