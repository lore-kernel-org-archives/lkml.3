Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3JHBod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:44:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44146 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3JHBob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:44:31 -0400
Message-ID: <5253637A.8080502@gmail.com>
Date: Mon, 07 Oct 2013 19:44:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] perf stat cleanups
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 9/28/13 2:27 PM, David Ahern wrote:
> Arnaldo:
>
> A few perf-stat cleanups.
>
> David Ahern (3):
>    perf stat: Fix misleading message when specifying cpu list or system wide
>    perf stat: Don't require a workload when using system wide or CPU options
>    perf stat: Add units to nanosec-based counters
>
>   tools/perf/builtin-stat.c |   15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
>

