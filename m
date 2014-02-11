Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaBKWti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:49:38 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:65340 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBKWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:49:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140210150614.c6a1b20553803da5f81acb72@linux-foundation.org>
References: <1387459407-29342-1-git-send-email-ddstreet@ieee.org>
 <1390831279-5525-1-git-send-email-ddstreet@ieee.org> <20140203150835.f55fd427d0ebb0c2943f266b@linux-foundation.org>
 <CALZtONAFF3F4j0KQX=ineJ1cOVEWJSGSe3V=Ja4x=3NguFAFMQ@mail.gmail.com> <20140210150614.c6a1b20553803da5f81acb72@linux-foundation.org>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 11 Feb 2014 17:49:15 -0500
X-Google-Sender-Auth: 8CQ8aYigy79HiVAlRIEwhUOKNy4
Message-ID: <CALZtONAHNzvOmNgY99i+QJcZFqdtxEgdmCck8h37vwYxfGTQPg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: add writethrough option
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjennings@variantweb.net>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 6:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 10 Feb 2014 14:05:14 -0500 Dan Streetman <ddstreet@ieee.org> wrote:
>
>> >
>> > It does sound like the feature is of marginal benefit.  Is "zswap
>> > filled up" an interesting or useful case to optimize?
>> >
>> > otoh the addition is pretty simple and we can later withdraw the whole
>> > thing without breaking anyone's systems.
>>
>> ping...
>>
>> you still thinking about this or is it a reject for now?
>
> I'm not seeing a compelling case for merging it and Minchan sounded
> rather unconvinced.  Perhaps we should park it until/unless a more
> solid need is found?


Sounds good.  I'll bring it back up if I find some solid need for it.  Thanks!
