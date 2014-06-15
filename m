Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaFONDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:03:16 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53866 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaFONDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:03:14 -0400
Subject: Re: perf: Add support for full Intel event lists v6
From: Namhyung Kim <namhyung@kernel.org>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org
In-Reply-To: <CAPh34mfkAXwD7tbscxj7TeN48TqMRY78LyU96YzdO34CoFXLng@mail.gmail.com>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
	 <CAPh34mfkAXwD7tbscxj7TeN48TqMRY78LyU96YzdO34CoFXLng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jun 2014 22:03:09 +0900
Message-ID: <1402837389.1684.25.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hagen,

2014-06-14 (토), 22:49 +0200, Hagen Paul Pfeifer:
> Probably too late, but IMHO the subcommand "download" is unhappy
> named. What is "downloaded"? traces? Python helper libs for
> perf-python support, I don't know it. What about "events-download",
> "events-database", ...

Hmm.. maybe we can add support something like above later - "perf
download event" or "perf download blabla".

But I have a different idea - leaving perf download as a plumbing tool,
and add --download option into the perf list to call it internally.
Maybe it can automatically download event file if it didn't find the
file in the local cache.


> 
> I also thought about further sub-command to delete the cache, update
> the cache, limit pull to specific vendors, ... I know this is the
> first shot and further subcommands can be added. But we will end up in
> something like
> E.g.:
> 
> perf events-download pull
> perf events-download pull --vendor amd
> perf events-download update
> perf events-download purge

Looks like 'event-cache' is a more appropriate name IMHO.

Anyway, thank you for the thought and suggestion. :)

Thanks,
Namhyung


