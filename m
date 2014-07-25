Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaGYXZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:25:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47821 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbaGYXY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:24:58 -0400
Message-Id: <1406330697.989.145785925.1CA960AF@webmail.messagingengine.com>
X-Sasl-Enc: N7oNolSxhCuGgTx+pFHsG0xSfIL89RlD5SHgdBr8wC0A 1406330697
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Jun Zhao <mypopydev@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Cong Wang <cwang@twopensource.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen hemminger <stephen@networkplumber.org>,
        Tom Herbert <therbert@google.com>, netdev@vger.kernel.org,
        Francesco Fusco <ffusco@redhat.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Stevens <dlstevens@us.ibm.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Daniel Borkmann <dborkman@redhat.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-36a9b403
In-Reply-To: <1406306339-16151-1-git-send-email-mypopydev@gmail.com>
References: <1406306339-16151-1-git-send-email-mypopydev@gmail.com>
Subject: Re: [PATCH 1/1] neighbour : fix ndm_type type error issue
Date: Sat, 26 Jul 2014 01:24:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014, at 18:38, Jun Zhao wrote:
> ndm_type means L3 address type, in neighbour proxy and vxlan, it's
> RTN_UNICAST.
> NDA_DST is for netlink TLV type, hence it's not right value in this
> context.

The value of NDA_DST == RTN_UNICAST, otherwise we couldn't do this
change as it would alter e.g. arpd behavior.

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Thanks,
Hannes
