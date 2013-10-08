Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3JHBpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:45:00 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49927 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3JHBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:44:59 -0400
Message-ID: <52536396.90109@gmail.com>
Date: Mon, 07 Oct 2013 19:44:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] perf trace enhancements
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/13 1:12 PM, David Ahern wrote:
> Hi Arnaldo:
>
> Some more enhancements to perf-trace. It is based on your perf/trace
> branch to keep the conflicts down based on the work you are doing.
>
> David Ahern (7):
>    perf util: Add machine method to loop over threads and invoke handler
>    perf trace: Use new machine method to loop over threads
>    perf trace: Fix comm resolution when reading events from file
>    perf trace: Add record option
>    perf util: Add priv variable to intlist
>    perf util: Add findnew method to intlist
>    perf trace: Add summary option to dump syscall statistics

Any comments on the enhancements?

