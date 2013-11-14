Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3KNUb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:31:57 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54742 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3KNUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:31:52 -0500
Message-ID: <52853334.9020304@gmail.com>
Date: Thu, 14 Nov 2013 13:31:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Remove thread summary coloring
References: <1384447410-1771-1-git-send-email-penberg@kernel.org>
In-Reply-To: <1384447410-1771-1-git-send-email-penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/13, 9:43 AM, Pekka Enberg wrote:
> Thread summary line coloring looks ugly.  It doesn't add much value so
> remove coloring completely.
>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>   tools/perf/builtin-trace.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
>

Looks good to me.
Acked-by: David Ahern <dsahern@gmail.com>

