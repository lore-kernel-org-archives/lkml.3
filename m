Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3C1Qgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:36:36 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41753 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab3C1Qge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:36:34 -0400
Message-ID: <51547175.409@cs.wisc.edu>
Date: Thu, 28 Mar 2013 11:36:05 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hong Zhiguo <honkiko@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, tgraf@suug.ch
Subject: Re: [PATCH 5/6] scsi: replace obsolete NLMSG_* with type safe nlmsg_*
References: <1364403195-32839-1-git-send-email-honkiko@gmail.com>
In-Reply-To: <1364403195-32839-1-git-send-email-honkiko@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 11:53 AM, Hong Zhiguo wrote:
> Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
> ---
>  drivers/scsi/scsi_netlink.c         |    4 +--
>  drivers/scsi/scsi_transport_fc.c    |   21 +++++--------
>  drivers/scsi/scsi_transport_iscsi.c |   56 +++++++++++++++++------------------
>  3 files changed, 38 insertions(+), 43 deletions(-)
> 

iscsi parts are ok. I also ran some quick tests on them.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

