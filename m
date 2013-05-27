Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3E0R4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:56:06 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38453 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3E0R4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:56:04 -0400
Message-ID: <51A39E30.5030708@cogentembedded.com>
Date: Mon, 27 May 2013 21:56:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: atomlin@redhat.com
CC: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        riel@redhat.com, aquini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
References: <1369599557-22677-1-git-send-email-atomlin@redhat.com>
In-Reply-To: <1369599557-22677-1-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-05-2013 0:19, atomlin@redhat.com wrote:

> From: Aaron Tomlin <atomlin@redhat.com>

> Since v1:
>   - Removed unnecessary parentheses

    The "changes since version X" section should typically go after --- 
tearline, else the mainatiner will have to edit your patch before applying.

> ---8<---

> Failed GFP_ATOMIC allocations by the network stack result in dropped
> packets, which will be received on a subsequent retransmit, and an
> unnecessary, noisy warning with a kernel backtrace.

> These warnings are harmless, but they still cause users to panic and
> file bug reports over dropped packets. It would be better to hide the
> failed allocation warnings and backtraces, and let retransmits handle
> dropped packets quietly.

> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>

WBR, Sergei

