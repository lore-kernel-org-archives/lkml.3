Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3AOTtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:49:16 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56577 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3AOTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:49:15 -0500
Message-ID: <50F5B2B8.4040506@linaro.org>
Date: Tue, 15 Jan 2013 11:49:12 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Subject: Re: [PATCH v2 2/3] rtc: Skip the suspend/resume handling if persistent
 clock exist
References: <1358266189-8812-1-git-send-email-feng.tang@intel.com> <1358266189-8812-2-git-send-email-feng.tang@intel.com>
In-Reply-To: <1358266189-8812-2-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 08:09 AM, Feng Tang wrote:
> All the RTC suspend and resume functions are to compensate the
> sleep time, but this is already done in timekeeping.c if persistent
> clock exist.
>

Applied. Thanks!
-john

