Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3AVVQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:16:36 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:17975 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3AVVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:16:34 -0500
Message-ID: <50FF01AB.4050401@hp.com>
Date: Tue, 22 Jan 2013 13:16:27 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: netdev@vger.kernel.org, criu@openvz.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH net-next] tcp: add ability to set a timestamp offset
References: <1358887953-28665-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1358887953-28665-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 12:52 PM, Andrey Vagin wrote:
> If a TCP socket will get live-migrated from one box to another the
> timestamps (which are typically ON) will get screwed up -- the new
> kernel will generate TS values that has nothing to do with what they
> were on dump. The solution is to yet again fix the kernel and put a
> "timestamp offset" on a socket.

Is there a chance a connection can be moved more than once within the 
"lifetime" of a given timestamp value?

rick jones

