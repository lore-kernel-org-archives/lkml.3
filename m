Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3A0VCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:02:31 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48701 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3A0VC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <1356141435-17340-5-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	<1356141435-17340-5-git-send-email-tj@kernel.org>
Date: Mon, 28 Jan 2013 00:02:27 +0300
Message-ID: <CA++WF2MqUbwGv1Fek2BntZkvg=whw4gXHUDaditTBsDPdBMGxw@mail.gmail.com>
Subject: Re: [PATCH 04/25] ipw2x00: simplify scan_event handling
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tejun,

On 22 December 2012 04:56, Tejun Heo <tj@kernel.org> wrote:
> * Drop unnesssary delayd_work_pending() tests.
>
> * Unify scan_event_{now|later} by using mod_delayed_work() w/ 0 delay
>   for scan_event_now.
>
> * Make ipw2200 scan_event handling match ipw2100 - use
>   mod_delayed_work() w/ 0 delay for immediate scanning.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

Please, feel free to take it through your tree.

Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Thanks!
Stanislav.
