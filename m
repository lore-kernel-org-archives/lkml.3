Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3LDHjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:39:55 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50191 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3LDHjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:39:41 -0500
Message-ID: <529EDC36.5050108@hitachi.com>
Date: Wed, 04 Dec 2013 16:39:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, namhyung@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/2] perf probe: Allow user to specify address within
 executable
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com> <529C259D.8010901@hitachi.com> <529C9DDF.1080401@gmail.com> <529CC97A.6000807@gmail.com> <529DA355.9090408@hitachi.com> <529DFF8E.2030806@gmail.com> <529E83C0.1060405@hitachi.com> <529E8903.7060907@gmail.com>
In-Reply-To: <529E8903.7060907@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/04 10:44), David Ahern wrote:
> On 12/3/13, 6:22 PM, Masami Hiramatsu wrote:
> 
>>> I figured out what you meant by uprobe_events interface yesterday. If I
>>> have to go to that interface for even 1 function I would do it for all
>>> -- from a user perspective it is just simpler to have 1 command to setup
>>> probes. I would prefer that 1 command be perf-probe.
>>
>> Yeah, but in that case, why you don't ask us adding sym->binding == STB_LOCAL
>> in filter_available_functions? :)
> 
> I did in a separate email -- you said because there can be multiple
> local functions with the same name.

Yeah, and this still seems to be a kind of workaround for me. The best way
to make you requirement enable is to support dwarf for userspace tracing.
OK I'll try it.

> But local functions is not the only
> use case I need.

What would you like to do with perf probe? Direct address accessing for
userspace is not a good way to do, because userspace is relocatable...

> For now I will carry the patch locally. At this point I am 20 patches
> deep and have probably another 20 to go. What's one more. I'll come back
> to this when I have more time.

Would you have any public git repository for that? And could you share
us what would you like to do before sending patch? We can help you to
tell the best way.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


