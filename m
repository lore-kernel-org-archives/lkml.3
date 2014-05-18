Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaERLov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 07:44:51 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:47056 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbaERLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 07:44:50 -0400
Message-ID: <53789CF1.5040402@mellanox.com>
Date: Sun, 18 May 2014 14:43:45 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx4_en: Fix uninitialized use of 'port_up' in mlx4_en_set_channels()
References: <1400363523-18371-1-git-send-email-cengelma@gmx.at>
In-Reply-To: <1400363523-18371-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/2014 12:52 AM, Christian Engelmayer wrote:
> Function mlx4_en_set_channels() stops running ports before performing the
> requested action. In that case local variable 'port_up' is set so that the
> port is restarted at the end of the function, however, in case the port was
> not stopped, variable 'port_up' is left uninitialized and the behaviour is
> undetermined. Detected by Coverity - CID 751497.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---

Acked-By: Amir Vadai <amirv@mellanox.com>

