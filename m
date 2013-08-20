Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3HTOTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:19:34 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52722 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3HTOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:19:33 -0400
Message-ID: <52137AF2.5070907@gmail.com>
Date: Tue, 20 Aug 2013 08:19:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
References: <1376931870-19912-1-git-send-email-dsahern@gmail.com> <20130819190603.GA1959@ghostprotocols.net>
In-Reply-To: <20130819190603.GA1959@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/13 1:06 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 19, 2013 at 11:04:30AM -0600, David Ahern escreveu:
>> Common arguments like thread id, CPU list, mmap pages, etc should be
>> consistent across perf commands.
>
> Ok, at some point I'll add a 'perf strace' alias that will resume trying
> to map the 'strace' single letter options.
>
> Can you check if this clashes with the -o patch I added today?

I just did remote update again and I do not see a -o patch in any of the 
branches.

David
