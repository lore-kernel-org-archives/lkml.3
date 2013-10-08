Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3JHNUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:20:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39395 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3JHNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:20:06 -0400
Message-ID: <52540685.2000306@gmail.com>
Date: Tue, 08 Oct 2013 07:20:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: perf sched lat segfault - bisected
References: <1381221715.15686.3.camel@marge.simpson.net>  <20131008121709.GA3955@infradead.org>  <1381235260.15686.38.camel@marge.simpson.net> <1381235727.15686.41.camel@marge.simpson.net>
In-Reply-To: <1381235727.15686.41.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 6:35 AM, Mike Galbraith wrote:
>
> (except replay segfaults, but lord knows when that last worked)

Fairly recently actually. I ran it early summer adding my timehist 
command to builtin-sched.c. I'll take a look later today.

David

