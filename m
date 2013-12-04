Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3LDBor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:44:47 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40210 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3LDBoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:44:44 -0500
Message-ID: <529E8903.7060907@gmail.com>
Date: Tue, 03 Dec 2013 18:44:35 -0700
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
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com> <529C259D.8010901@hitachi.com> <529C9DDF.1080401@gmail.com> <529CC97A.6000807@gmail.com> <529DA355.9090408@hitachi.com> <529DFF8E.2030806@gmail.com> <529E83C0.1060405@hitachi.com>
In-Reply-To: <529E83C0.1060405@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/13, 6:22 PM, Masami Hiramatsu wrote:

>> I figured out what you meant by uprobe_events interface yesterday. If I
>> have to go to that interface for even 1 function I would do it for all
>> -- from a user perspective it is just simpler to have 1 command to setup
>> probes. I would prefer that 1 command be perf-probe.
> 
> Yeah, but in that case, why you don't ask us adding sym->binding == STB_LOCAL
> in filter_available_functions? :)

I did in a separate email -- you said because there can be multiple
local functions with the same name. But local functions is not the only
use case I need.

For now I will carry the patch locally. At this point I am 20 patches
deep and have probably another 20 to go. What's one more. I'll come back
to this when I have more time.

Thanks,

David
