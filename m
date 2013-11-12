Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3KLQld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:41:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40508 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab3KLQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:41:30 -0500
X-Sasl-enc: /2A3+aPZMYulZd+VPy6C8sL7Oth/9y7it0dOw1vJwctS 1384274489
Message-ID: <52825A37.2050002@iki.fi>
Date: Tue, 12 Nov 2013 18:41:27 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] perf trace: Add summary only option
References: <1384273875-3751-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1384273875-3751-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 06:31 PM, David Ahern wrote:
> Per request from Pekka make --summary a summary only option meaning do not
> show the individual system calls. Add another option to see all syscalls
> along with the summary. In addition use 's' and 'S' as shortcuts for the
> options.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> ---

Thanks David!

Tested-by: Pekka Enberg <penberg@kernel.org>
