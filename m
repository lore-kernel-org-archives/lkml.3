Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaFMODp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:03:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:37631 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaFMODo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:03:44 -0400
Date: Fri, 13 Jun 2014 16:03:36 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] tools:perf: move tools/perf/util to tools/lib/perf_util
Message-ID: <20140613140336.GF27560@rric.localhost>
References: <1402561602-28807-1-git-send-email-jean.pihet@linaro.org>
 <20140612123432.GA2608@kernel.org>
 <20140612124918.GC4857@pd.tnic>
 <CAFrcx1kfUkFF9ROy2C0gcFe88aOHfv2qJBfO+uv+Z7ZW5HxQCw@mail.gmail.com>
 <20140612140119.GD4857@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612140119.GD4857@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.14 16:01:20, Borislav Petkov wrote:
> Additionally, if you'd like, we could sync among each other on who does
> what. Maybe Robert would like to help too.

As long as I stick with the persistent event kernel patches I don't
think I will have the time to work on further userspace changes.

-Robert
