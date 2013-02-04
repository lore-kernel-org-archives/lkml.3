Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3BDQAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:00:47 -0500
Received: from smtp.opengridcomputing.com ([72.48.136.20]:43200 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198Ab3BDQAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:00:45 -0500
X-Greylist: delayed 1707 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 11:00:45 EST
Message-ID: <510FD48A.1080200@opengridcomputing.com>
Date: Mon, 04 Feb 2013 09:32:26 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 25/62] infiniband/cxgb4: convert to idr_alloc()
References: <1359854463-2538-1-git-send-email-tj@kernel.org> <1359854463-2538-26-git-send-email-tj@kernel.org>
In-Reply-To: <1359854463-2538-26-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
