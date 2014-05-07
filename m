Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaEGURl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:17:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaEGURi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:17:38 -0400
Date: Wed, 07 May 2014 16:16:49 -0400 (EDT)
Message-Id: <20140507.161649.9479206877775994.davem@redhat.com>
To: decot@googlers.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, edumazet@google.com, ebiederm@xmission.com,
        chenweilong@huawei.com, jiri@resnulli.us, mwdalton@google.com,
        viro@ZenIV.linux.org.uk, tj@kernel.org
Subject: Re: [PATCH v1] net-sysfs: expose permanent hardware address in
 sysfs
From: David Miller <davem@redhat.com>
In-Reply-To: <cd90d330753ff145d209240a72caafac32f5e750.1399347193.git.decot@googlers.com>
References: <cover.1399347193.git.decot@googlers.com>
	<cd90d330753ff145d209240a72caafac32f5e750.1399347193.git.decot@googlers.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Mon,  5 May 2014 20:34:00 -0700

> Tested:
>   grep . /sys/class/net/*/*addr*
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

ETHTOOL_GPERMADDR exists already, please use that instead, thanks.
