Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3CSBUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:20:48 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:55841 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3CSBUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:20:46 -0400
Message-ID: <5147BD6A.2010404@igel.co.jp>
Date: Tue, 19 Mar 2013 10:20:42 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] drivers: uio_dmem_genirq: Use of_match_ptr() macro
References: <1363256545-30687-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1363256545-30687-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/03/14 19:22, Sachin Kamat wrote:
> This eliminates having an #ifdef returning NULL for the case
> when OF is disabled.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> ---
Thank you,
Looks fine by me.

Acked-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>


