Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaFXClV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:41:21 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:35971 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbaFXClU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:41:20 -0400
Message-ID: <53A8E548.9060008@akamai.com>
Date: Mon, 23 Jun 2014 22:41:12 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 0/3] static keys: fix test/set races
References: <cover.1372457176.git.jbaron@akamai.com> <20140623222802.4900881c@gandalf.local.home>
In-Reply-To: <20140623222802.4900881c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 10:28 PM, Steven Rostedt wrote:
> Cleaning out my INBOX I found this patch series. It seems to have been
> forgotten about. It ended up with Ingo and Peter agreeing with the way
> things should be done and I thought Jason was going to send an update.
> But that seems to never have happened.
>
> Does this patch series still look legit? Should we pursue it?
>
> -- Steve

Hi Steve,

I still think its a reasonable addition - I'll re-post later
this week for comments.

Thanks,

-Jason
