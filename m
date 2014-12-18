Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaLREca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:32:30 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42808 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaLREc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:32:29 -0500
Message-ID: <549258DB.1010408@gmail.com>
Date: Wed, 17 Dec 2014 21:32:27 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
References: <1418848148-35919-1-git-send-email-dsahern@gmail.com> <20141218042632.GB20215@sejong>
In-Reply-To: <20141218042632.GB20215@sejong>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/14 9:26 PM, Namhyung Kim wrote:
>
> It'd be better if we do it like below..
>
> 	char i = *ptr++;
>
> Why not passing ptr + 1 to print_ip_arg()?
>

That parsing loop is a bit weird - and deep. And I only wanted to 
consume 'pi' and 'pI' with parse_ip_arg if and only if the next letters 
are '4', '6' and 'S'.

David

