Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3E1TQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:16:46 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43253 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3E1TQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:16:44 -0400
Message-ID: <51A50299.9090909@linaro.org>
Date: Tue, 28 May 2013 12:16:41 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktime: minor: ktime_to_timespec_cond: add __must_check
 prefix
References: <1368712069-522-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1368712069-522-1-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 06:47 AM, Daniel Borkmann wrote:
> The function is currently mainly used in the networking code and
> if others start using it, they must check the result, otherwise
> it cannot be determined if the timespec conversion suceeded.
> Currently no user lacks this check, but make future users aware of
> a possible misusage.
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

I've got this queued for 3.11. Sorry for being slow to pick this up!

thanks!
-john

