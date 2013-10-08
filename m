Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3JHK5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:57:16 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:63571 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3JHK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <1381229810.15686.19.camel@marge.simpson.net>
References: <1381221715.15686.3.camel@marge.simpson.net>
	<CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
	<1381227252.15686.9.camel@marge.simpson.net>
	<1381227659.15686.11.camel@marge.simpson.net>
	<CABPqkBQD9TE7RbP-auXO060aU1QNU=RUw2QZvoF39CCqpzdC4w@mail.gmail.com>
	<CABPqkBSpTPttig8uKdR2KJba8rwOe3P1sKPjkVizVGH=H+w-9Q@mail.gmail.com>
	<1381229421.15686.17.camel@marge.simpson.net>
	<CABPqkBQzgfxYLbpJFy3bWZZWby4X92+q6za5S7o6QXjk6qkmFg@mail.gmail.com>
	<1381229810.15686.19.camel@marge.simpson.net>
Date: Tue, 8 Oct 2013 12:57:13 +0200
Message-ID: <CABPqkBQAvmSnt4t6=+z2FYv5cQ0BcgsCr_rhZo0qwif8jL5q=g@mail.gmail.com>
Subject: Re: perf: perf sched lat segfault - bisected
From: Stephane Eranian <eranian@google.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 12:56 PM, Mike Galbraith <bitbucket@online.de> wrote:
> On Tue, 2013-10-08 at 12:51 +0200, Stephane Eranian wrote:
>> Mike,
>>
>> I posted the fix now.
>
> I tested it just in case, works fine.
>
Thanks.

> -Mike
>
