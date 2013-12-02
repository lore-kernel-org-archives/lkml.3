Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3LBFyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:54:09 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52281 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3LBFxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:53:51 -0500
Message-ID: <529C2067.7020206@hitachi.com>
Date: Mon, 02 Dec 2013 14:53:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, namhyung@kernel.org
Subject: Re: [PATCH 2/2] perf probe: Allow user to specify address within
 executable
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com> <1385942827-11637-2-git-send-email-dsahern@gmail.com>
In-Reply-To: <1385942827-11637-2-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/02 9:07), David Ahern wrote:
> Allow user to specify an address within an executable. This is useful, for
> example, in probing local functions. If the function name begins with 0x
> then try to convert the supplied name to an address. If succuessful then
> treat the function name as the address within the executable to be probed.

Hmm, IMHO, this kind of functionality is only good for debugging.
In that case, you should use uprobe_events interface directly.

I recommend you to try enabing dwarf support in user space.
Perf probe is a user-friendly interface of dynamic events.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


