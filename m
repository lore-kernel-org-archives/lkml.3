Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaCMQfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbaCMQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:35:47 -0400
Date: Thu, 13 Mar 2014 12:35:31 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC PATCH v2] Tracepoint: register/unregister struct tracepoint
Message-ID: <20140313163531.GD14899@redhat.com>
References: <1394727048-11204-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394727048-11204-1-git-send-email-mathieu.desnoyers@efficios.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Mar 13, 2014 at 12:10:48PM -0400, Mathieu Desnoyers wrote:

> [...]  Moreover, tracers are responsible for unregistering the probe
> before the module containing its associated tracepoint is unloaded.

Could you spell out please how a tracer is supposed to know early
enough that the module is going to be unloaded?

- FChE
