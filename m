Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaCOSEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 14:04:33 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36908 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbaCOSEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 14:04:32 -0400
Date: Sat, 15 Mar 2014 19:04:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/10] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140315180429.GD22728@two.firstfloor.org>
References: <1394832698-322-1-git-send-email-andi@firstfloor.org>
 <1394832698-322-2-git-send-email-andi@firstfloor.org>
 <5323859B.70201@gmail.com>
 <20140315022707.GB22728@two.firstfloor.org>
 <20140315130417.GD14945@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140315130417.GD14945@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will this be useful for all arches?

Yes they could define their own JSON files, perhaps with minor
extensions of the parser and a new download sites in the downloader.

-Andi
