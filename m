Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab3KLVmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:42:17 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63242 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3KLVmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:42:10 -0500
Message-ID: <5282A0AF.9050603@gmail.com>
Date: Tue, 12 Nov 2013 14:42:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>, Ingo Molnar <mingo@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
References: <1384267334-18953-1-git-send-email-penberg@kernel.org> <20131112213334.GF25913@gmail.com> <52829F4F.6070800@gmail.com> <52829FB8.6070404@iki.fi>
In-Reply-To: <52829FB8.6070404@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13, 2:38 PM, Pekka Enberg wrote:
> Sorry about that. Why do we show them in percentages, btw? Standard
> deviation is usually represented in the same unit as the data to make it
> readable.
>

Consistency. perf-stat shows relative stddev, for example.

David


