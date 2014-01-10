Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaAJNsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:48:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaAJNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:48:39 -0500
Message-ID: <52CFFA23.3050300@oracle.com>
Date: Fri, 10 Jan 2014 08:48:19 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCH 01/12] kernfs: fix get_active failure handling in kernfs_seq_*()
References: <1389117590-25705-1-git-send-email-tj@kernel.org> <1389117590-25705-2-git-send-email-tj@kernel.org>
In-Reply-To: <1389117590-25705-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 12:59 PM, Tejun Heo wrote:
> Sasha, I*think*  this chould be the fix for the problem you reported
> with trinity fuzzying.  Is the problem reproducible?  If so, can you
> please test it with this patch applied?

It didn't reproduce too often in the past. I've been running this patch
and didn't see the issue happening, so it looks good so far.


Thanks,
Sasha
