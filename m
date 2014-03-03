Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaCCNNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:13:36 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45186 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982AbaCCNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:13:35 -0500
X-Sasl-enc: ZzR6RLcG8eIGvBOEWiJCxDJDivzW5ys8M5x3h0VaZcyL 1393852414
Message-ID: <53147FFB.9040905@iki.fi>
Date: Mon, 03 Mar 2014 15:13:31 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 02/13] perf ui/gtk: Reuse generic __hpp__fmt() code
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org> <1393809254-4480-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1393809254-4480-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 03:14 AM, Namhyung Kim wrote:
> The __hpp__color_fmt used in the gtk code can be replace by the
> generic code with small change in print_fn callback.
>
> This is a preparation to upcoming changes and no functional changes
> intended.
>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
