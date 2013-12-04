Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3LDBXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:23:54 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37850 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3LDBXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:23:52 -0500
Message-ID: <529E8421.3020602@hitachi.com>
Date: Wed, 04 Dec 2013 10:23:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/2] perf probe: Improve error message when function not
 found
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <529C21C5.3030007@hitachi.com> <529C9EC0.70607@gmail.com> <529D6824.1020006@hitachi.com> <529DF5A9.1000509@gmail.com>
In-Reply-To: <529DF5A9.1000509@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/04 0:15), David Ahern wrote:
> On 12/2/13, 10:12 PM, Masami Hiramatsu wrote:
>>> That needs to be explicitly stated in the error message -- only global
>>> symbols may be given.
>>
>> Ah, I see. In that case, I think the "variable" is not a correct word,
>> the "symbol" is better, because perf probe can take tracing variable
>> arguments after the trace point definition. :)
> 
> Right, variable is not the correct word. So how about this:
> 
> "Failed to find requested symbol in %s. Is it a global symbol?"

Yeah, that's good for me now :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


