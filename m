Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaEHSYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:24:48 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35479 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaEHSYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140507225206.ea7cff02caf1118bb4b5a48d@skynet.be>
References: <20140507225206.ea7cff02caf1118bb4b5a48d@skynet.be>
Date: Thu, 8 May 2014 14:24:47 -0400
X-Google-Sender-Auth: ORDUwJxCPeQyTdb-qPsT0-fIbAI
Message-ID: <CAOS58YMZYnqNzpa8RqGk+btp_RkUdPry4NstJU22qzEOh_+5zw@mail.gmail.com>
Subject: Re: [PATCH V2] MM: make vmpressure_win dynamic
From: Tejun Heo <tj@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 4:52 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Initialize vmpressure_win in vmstat using
> calculate_normal_threshold() based on each zone/cpu * SWAP_CLUSTER_SIZE
>
> Value refreshed through cpu notifier and exposed in read-only through /sys/kernel
>
> This is untested.
>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Please cc memcg maintainers.  Thanks.

-- 
tejun
