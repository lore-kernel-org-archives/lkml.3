Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3GIKHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:07:11 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62469 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3GIKHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0mzzYsK04gvnQXbkJ0Q8PAeDur3zO8f5KVDDjQ7dhHUjQ@mail.gmail.com>
References: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
 <1372945246-21605-3-git-send-email-artagnon@gmail.com> <878v1lzqe3.fsf@sejong.aot.lge.com>
 <20130706191237.GA2468@shutemov.name> <CALkWK0mzzYsK04gvnQXbkJ0Q8PAeDur3zO8f5KVDDjQ7dhHUjQ@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 9 Jul 2013 15:36:28 +0530
Message-ID: <CALkWK0mhpsKNKip8nztNSFHPerPzkSng7NsLoouXoh8OMh_nCg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: squelch warnings from perl.h to compile-pass
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
>> This one: https://lkml.org/lkml/2013/6/24/66 ?
>
> Yeah, I think this is more sensible than my approach.

Thanks to Namhyung, I think my v3 is better now:
http://article.gmane.org/gmane.linux.kernel/1522137
