Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3JHK44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:56:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3JHK4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:56:54 -0400
Message-ID: <1381229810.15686.19.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 08 Oct 2013 12:56:50 +0200
In-Reply-To: <CABPqkBQzgfxYLbpJFy3bWZZWby4X92+q6za5S7o6QXjk6qkmFg@mail.gmail.com>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
	 <1381227252.15686.9.camel@marge.simpson.net>
	 <1381227659.15686.11.camel@marge.simpson.net>
	 <CABPqkBQD9TE7RbP-auXO060aU1QNU=RUw2QZvoF39CCqpzdC4w@mail.gmail.com>
	 <CABPqkBSpTPttig8uKdR2KJba8rwOe3P1sKPjkVizVGH=H+w-9Q@mail.gmail.com>
	 <1381229421.15686.17.camel@marge.simpson.net>
	 <CABPqkBQzgfxYLbpJFy3bWZZWby4X92+q6za5S7o6QXjk6qkmFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Xe2fc5Ra4s0qk24LMKNczLJ6xmbf+2zVXCIt03EPsG8
 W8eb32vqmxlqD1w+TUX1gEYYb4A5UqEpieQ/LCmqMwYr9FKFE9
 +y+GTe0UxcSZ3jii1TT8RMcdeFrmXaxUNiPZM9AcymQMYknuTK
 SMLN/sG8Drbyww48yCZ13Geti00aRYxkqY+P8mrkAsOHFG4znz
 Ny270l6Cmtz1vbJ1u4TYWG0gNaViS7Tdgzh8bg7xqp4x1uEX0I
 KRvklvpd+Y3568Kcsa3MwlhQ+169LKpo0Y4o7l+9ypqRir5Zsq
 4g/f26zhxz3m063fXlmANZ3OVYGYAJwuxKrcoI3wNyJRMufmFC
 J/moHHcMUCt5bzWJLFZ+2hpFS28+3lmr4DR5fGJH4RHKYQpipn
 QyHNQEa2rjCOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 12:51 +0200, Stephane Eranian wrote: 
> Mike,
> 
> I posted the fix now.

I tested it just in case, works fine.

-Mike

