Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaFNV2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:28:12 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35187 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaFNV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:28:12 -0400
Date: Sat, 14 Jun 2014 23:28:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v6
Message-ID: <20140614212809.GF5714@two.firstfloor.org>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
 <CAPh34mfkAXwD7tbscxj7TeN48TqMRY78LyU96YzdO34CoFXLng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPh34mfkAXwD7tbscxj7TeN48TqMRY78LyU96YzdO34CoFXLng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 10:49:35PM +0200, Hagen Paul Pfeifer wrote:
> Probably too late, but IMHO the subcommand "download" is unhappy
> named. What is "downloaded"? traces? Python helper libs for
> perf-python support, I don't know it. What about "events-download",
> "events-database", ...

I prefer just download.

> 
> I also thought about further sub-command to delete the cache, update
> the cache, limit pull to specific vendors, ... I know this is the
> first shot and further subcommands can be added. But we will end up in
> something like

The sub commands don't make a lot of sense, as the event list is only 
useful for the current system.

-Andi
