Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3GPTBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:01:54 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:63154 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab3GPTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:01:51 -0400
Message-ID: <51E5972C.4060306@twiddle.net>
Date: Tue, 16 Jul 2013 11:55:40 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 3/7] alpha: Modernize lib/mpi/longlong.h
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>  <1373994280-12047-4-git-send-email-rth@twiddle.net> <1373995159.1949.8.camel@joe-AO722>
In-Reply-To: <1373995159.1949.8.camel@joe-AO722>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 10:19 AM, Joe Perches wrote:
> On Tue, 2013-07-16 at 10:04 -0700, Richard Henderson wrote:
>> Remove the compile warning for __udiv_qrnnd not having a prototype.
>> Use the __builtin_alpha_umulh introduced in gcc 4.0.
> 
> Isn't gcc 3.x still a supported compiler?

Further investigation shows the builtin was added for gcc 3.2.
I just failed to update gcc's own longlong.h til 3 years later.

r~
