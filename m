Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3LCPP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:15:59 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50420 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3LCPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:15:55 -0500
Message-ID: <529DF5A9.1000509@gmail.com>
Date: Tue, 03 Dec 2013 08:15:53 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/2] perf probe: Improve error message when function not
 found
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <529C21C5.3030007@hitachi.com> <529C9EC0.70607@gmail.com> <529D6824.1020006@hitachi.com>
In-Reply-To: <529D6824.1020006@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 10:12 PM, Masami Hiramatsu wrote:
>> That needs to be explicitly stated in the error message -- only global
>> symbols may be given.
> 
> Ah, I see. In that case, I think the "variable" is not a correct word,
> the "symbol" is better, because perf probe can take tracing variable
> arguments after the trace point definition. :)

Right, variable is not the correct word. So how about this:

"Failed to find requested symbol in %s. Is it a global symbol?"

David
