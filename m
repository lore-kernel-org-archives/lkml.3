Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3JDBMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 21:12:37 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:58687 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751628Ab3JDBMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 21:12:34 -0400
Date: Fri, 4 Oct 2013 10:12:16 +0900
From: takasi-y@ops.dti.ne.jp
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ARM: shmobile: kzm9d-reference:  migrate to common
 clock framework with DT
Message-Id: <20131004101216.5dd1327a1a03171968a09232@ops.dti.ne.jp>
In-Reply-To: <87siwtl69z.wl%kuninori.morimoto.gx@renesas.com>
References: <52410F86.4040301@renesas.com>
	<87siwtl69z.wl%kuninori.morimoto.gx@renesas.com>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
> Documentation and implementation in one patch,
> and dts in other patch, are normal style IMO

That's strange! Considering the nature of DT, it must be wrong.
... was what I thought at first, but you are right.
I found 3/4 (1021 in 1365) of commits (new + change - typo fix)
under Documentation/devicetree/bindings/ has come with .c code.

Thank you for let me know.
/yoshii
