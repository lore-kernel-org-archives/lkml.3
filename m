Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3JaItW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:49:22 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63049 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3JaItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <527218F4.3090006@ti.com>
References: <1382678784-20191-1-git-send-email-sachin.kamat@linaro.org>
	<527218F4.3090006@ti.com>
Date: Thu, 31 Oct 2013 14:19:19 +0530
Message-ID: <CAK9yfHxgivL9jHUNM82vTOfeC6H5JUaBP7exxc2sie1Hk4jGJA@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: phy: Fix memory leak
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2013 14:16, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Friday 25 October 2013 10:56 AM, Sachin Kamat wrote:
>> 'phy' was not being freed upon error in one of the cases.
>> Adjust the 'goto's to fix this.
>
> This patch looks good. I'll send this once -rc1 is tagged?

Sure. Thanks.

-- 
With warm regards,
Sachin
