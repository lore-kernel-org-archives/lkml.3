Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab3BFWdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:33:44 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:43481 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3BFWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:33:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130206143256.21a55902.akpm@linux-foundation.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
	<1360179649-22465-22-git-send-email-tj@kernel.org>
	<20130206142422.b2f8eac6.akpm@linux-foundation.org>
	<20130206222755.GD2875@htj.dyndns.org>
	<20130206143256.21a55902.akpm@linux-foundation.org>
Date: Wed, 6 Feb 2013 14:33:39 -0800
X-Google-Sender-Auth: dNzwDtdJB_kHwLM9-oiNp8lzzKg
Message-ID: <CAOS58YNfTaPRZb-8xVtcycFPDW2w-SmNMdrK5FGp8Puv8S1EPQ@mail.gmail.com>
Subject: Re: [PATCH 21/77] block: fix synchronization and limit check in blk_alloc_devt()
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Henzl <thenzl@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 6, 2013 at 2:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Can you please drop 21 and 22?  Everything else shouldn't be affected
>> and we can sort these out later.  The actual deprecation patch is held
>> off for now anyway.
>
> hm, I could.  Instead I merged your patch on top of Tomas's and marked
> Tomas's patch for -stable as well.  Sound OK?

Sure, less work for me. :)

-- 
tejun
