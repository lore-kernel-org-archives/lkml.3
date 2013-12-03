Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3LCP6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:58:13 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50905 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3LCP6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:58:10 -0500
Message-ID: <529DFF8E.2030806@gmail.com>
Date: Tue, 03 Dec 2013 08:58:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, namhyung@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/2] perf probe: Allow user to specify address within
 executable
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com> <529C259D.8010901@hitachi.com> <529C9DDF.1080401@gmail.com> <529CC97A.6000807@gmail.com> <529DA355.9090408@hitachi.com>
In-Reply-To: <529DA355.9090408@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/13, 2:24 AM, Masami Hiramatsu wrote:
> I don't want to make perf-probe just a wrapper of the ftrace dynamic
> event interface, because it doesn't add any "value" for users.

Sure it does -- a consistent user experience in using a single command
(perf probe ...) for setting up userspace probes.

Specifying the address directly is really on par with perf-record having
the rNNN interface for directly passing the raw event id to the kernel.

> 
>>>> In that case, you should use uprobe_events interface directly.
>>>
>>> How do I do that within the context of perf?
> 
> No way, but here, you can save this script as perf-uprobe and
> can use it for that purpose. :)

I figured out what you meant by uprobe_events interface yesterday. If I
have to go to that interface for even 1 function I would do it for all
-- from a user perspective it is just simpler to have 1 command to setup
probes. I would prefer that 1 command be perf-probe.

David

