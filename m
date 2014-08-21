Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaHUIsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbaHUIsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:48:16 -0400
Message-ID: <53F5B22A.5010307@redhat.com>
Date: Thu, 21 Aug 2014 10:47:38 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zhu Yanjun <zyjzyj2000@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com,
        tuexen@fh-muenster.de, khandelwal.deepak.1987@gmail.com,
        Yue.Tao@windriver.com, alexandre.dietsch@windriver.com,
        davem@davemloft.net, Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: Re: [PATCH 1/1] sctp: not send SCTP_PEER_ADDR_CHANGE notifications
 with failed probe
References: <1408527103-22772-1-git-send-email-Yanjun.Zhu@windriver.com> <1408527103-22772-2-git-send-email-Yanjun.Zhu@windriver.com>
In-Reply-To: <1408527103-22772-2-git-send-email-Yanjun.Zhu@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 11:31 AM, Zhu Yanjun wrote:
> Since the transport has always been in state SCTP_UNCONFIRMED, it
> therefore wasn't active before and hasn't been used before, and it
> always has been, so it is unnecessary to bug the user with a
> notification.
>
> Reported-by: Deepak Khandelwal <khandelwal.deepak.1987@gmail.com>
> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
> Suggested-by: Michael Tuexen <tuexen@fh-muenster.de>
> Suggested-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>

Looks a bit better, thanks!

Acked-by: Daniel Borkmann <dborkman@redhat.com>
