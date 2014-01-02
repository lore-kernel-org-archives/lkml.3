Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaABXRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:17:38 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52476 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaABXRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:17:36 -0500
Message-ID: <52C5F38D.5060201@linaro.org>
Date: Thu, 02 Jan 2014 15:17:33 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org
CC: anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] Deferrable timers support for timerfd API
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
In-Reply-To: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 10:30 AM, Alexey Perevalov wrote:
> This version introduces new clockid (CLOCK_DEFERRABLE) , for timerfd_create, instead of
> new flag (TFD_TIMER_DEFERRABLE) for timerfd_settime introduced in previous version.

So why did you make this change?

thanks
-john

