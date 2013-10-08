Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3JHFqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:46:45 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:44250 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab3JHFqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:46:43 -0400
Message-ID: <52539BB5.2020207@mellanox.com>
Date: Tue, 8 Oct 2013 08:44:21 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Roi Dayan <roid@mellanox.com>, Roland Dreier <roland@kernel.org>,
        "Sean Hefty" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iscsi_iser: Add missing newlines to logging messages
References: <1381185890.2081.223.camel@joe-AO722>
In-Reply-To: <1381185890.2081.223.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 01:44, Joe Perches wrote:
> Logging messages need terminating newlines to avoid
> possible message interleaving.  Add them.
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
