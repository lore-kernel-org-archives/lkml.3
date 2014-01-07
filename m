Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbaAGBsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:48:12 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:58776 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbaAGBsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:48:11 -0500
MIME-Version: 1.0
In-Reply-To: <20140104.210556.1496163796108456860.davem@davemloft.net>
References: <1386773661-921-1-git-send-email-ethan.kernel@gmail.com>
	<20140104.210556.1496163796108456860.davem@davemloft.net>
Date: Tue, 7 Jan 2014 09:48:10 +0800
Message-ID: <CABawtvO_dQ4Br6MAMHHmSK3xeFGywf-=1w3-VB+V7yVFo4=5kg@mail.gmail.com>
Subject: Re: [PATCH] sparc: replace __GFP_NOFAIL with GFP_ATOMIC in mdesc_kmalloc()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
   Got it. thanks,


Ethan

On Sun, Jan 5, 2014 at 10:05 AM, David Miller <davem@davemloft.net> wrote:
> From: Ethan Zhao <ethan.kernel@gmail.com>
> Date: Wed, 11 Dec 2013 22:54:21 +0800
>
>> Has kmalloc() failure checking there, so it is unnecessary to allocate with
>> __GFP_NOFAIL flag that might block forever.
>>
>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>
> Please submit sparc patches with sparclinux@vger.kernel.org at least
> CC:'d.
