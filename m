Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaGXJnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:43:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48645 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbaGXJnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:43:37 -0400
Date: Thu, 24 Jul 2014 12:43:33 +0300
From: Eli Cohen <eli@dev.mellanox.co.il>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/1] IB/mlx5: use ARRAY_SIZE instead of sizeof/sizeof[0]
Message-ID: <20140724094333.GB23437@mtldesk30>
References: <1404244724-24528-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404244724-24528-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Jul 01, 2014 at 09:58:44PM +0200, Fabian Frederick wrote:
> use macro definition

Acked-by: Eli Cohen <eli@mellanox.com>

