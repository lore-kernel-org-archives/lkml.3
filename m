Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaLRP75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:59:57 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56518 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaLRP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:59:56 -0500
Message-ID: <5492F9F9.7090207@gmail.com>
Date: Thu, 18 Dec 2014 08:59:53 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com> <20141218155255.GF3150@kernel.org>
In-Reply-To: <20141218155255.GF3150@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/14 8:52 AM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 18, 2014 at 08:10:43AM -0700, David Ahern escreveu:
>> Adds helper for following kernel formats:
>>    %pi4 print an IPv4 address with leading zeros
>>    %pI4 print an IPv4 address without leading zeros
>>    %pi6 print an IPv6 address without colons
>>    %pI6 print an IPv6 address with colons
>>    %pI6c print an IPv6 address with colons
>>    %pISpc print an IP address from a sockaddr
>>
>> Allows these formats to be used in tracepoints.
>>
>> Quite a bit of this is adapted from code in lib/vsprintf.c.
>
> Can't we try as much as possible use that code directly? Something like

By my reading of that file I don't see how it can be reused directly.

David

