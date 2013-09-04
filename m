Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab3IDP6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:58:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20799 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935220Ab3IDP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:58:51 -0400
X-IronPort-AV: E=Sophos;i="4.89,1021,1367971200"; 
   d="scan'208";a="48100439"
Message-ID: <522758B5.6070607@citrix.com>
Date: Wed, 4 Sep 2013 16:58:45 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] tracing/events: Add bounce tracing to swiotbl-xen
References: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com> <20130822180209.07a2bd00@gandalf.local.home>
In-Reply-To: <20130822180209.07a2bd00@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/13 23:02, Steven Rostedt wrote:
> Please use a more specific name. "bounce" is too generic. I know
> tracepoints are grouped by systems, but its easier for tools to just
> state a tracepoint name than the system:event pair.

Sure, see my v2 patch coming soon.

Zoli
