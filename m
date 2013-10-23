Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3JWIkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:40:09 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3JWIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:40:07 -0400
Date: Wed, 23 Oct 2013 10:40:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf test failing for "sample parsing"
Message-ID: <20131023084004.GJ29695@two.firstfloor.org>
References: <20131022183539.GA18057@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022183539.GA18057@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	This one was harmless, but there were problems that were caught
> by running 'perf test' while writing patchkits,

Thanks for fixing. I'll run it in the future.

-Andi
