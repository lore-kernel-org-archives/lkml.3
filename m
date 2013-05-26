Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3EZQcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 12:32:21 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49341 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3EZQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 12:32:20 -0400
Message-ID: <51A23911.3060802@gmail.com>
Date: Sun, 26 May 2013 12:32:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        kzak@redhat.com, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        riel@redhat.com, lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [PATCH 02/02] swapon: allow a more flexible swap discard policy
References: <cover.1369529143.git.aquini@redhat.com> <6346c223ca2acb30b35480b9d51638466aac5fe6.1369530033.git.aquini@redhat.com>
In-Reply-To: <6346c223ca2acb30b35480b9d51638466aac5fe6.1369530033.git.aquini@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/26/13 12:31 AM), Rafael Aquini wrote:
> Introduce the necessary changes to swapon(8) allowing a sysadmin to leverage
> the new changes introduced to sys_swapon by "swap: discard while swapping
> only if SWAP_FLAG_DISCARD_PAGES", therefore allowing a more flexible set of
> choices when selection the discard policy for mounted swap areas.
> This patch introduces the following optional arguments to the already
> existent swapon(8) "--discard" option, in order to allow a discard type to 
> be selected at swapon time:
>  * once    : only single-time area discards are issued. (swapon)
>  * pages   : discard freed pages before they are reused.
> If no policy is selected both discard types are enabled. (default)
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



