Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaFNUti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:49:38 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51717 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaFNUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:49:36 -0400
MIME-Version: 1.0
X-Originating-IP: [2a02:810d:740:57c:6a05:caff:fe03:ab31]
In-Reply-To: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
Date: Sat, 14 Jun 2014 22:49:35 +0200
Message-ID: <CAPh34mfkAXwD7tbscxj7TeN48TqMRY78LyU96YzdO34CoFXLng@mail.gmail.com>
Subject: Re: perf: Add support for full Intel event lists v6
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably too late, but IMHO the subcommand "download" is unhappy
named. What is "downloaded"? traces? Python helper libs for
perf-python support, I don't know it. What about "events-download",
"events-database", ...

I also thought about further sub-command to delete the cache, update
the cache, limit pull to specific vendors, ... I know this is the
first shot and further subcommands can be added. But we will end up in
something like
E.g.:

perf events-download pull
perf events-download pull --vendor amd
perf events-download update
perf events-download purge

Hagen
