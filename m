Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaLSDId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:08:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaLSDIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:08:32 -0500
Date: Fri, 19 Dec 2014 03:16:21 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net] net: drop the packet when fails to do software
 segmentation or header check
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Message-Id: <1418958501.8471.0@smtp.corp.redhat.com>
In-Reply-To: <20141218.153912.942123862967427213.davem@davemloft.net>
References: <1418882239-6720-1-git-send-email-jasowang@redhat.com>
	<20141218.153912.942123862967427213.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Dec 19, 2014 at 4:39 AM, David Miller <davem@davemloft.net> 
wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Thu, 18 Dec 2014 13:57:19 +0800
> 
>>  Fixes cecda693a969816bac5e470e1d9c9c0ef5567bca
> 
> Please correct this fixes tag, it should be of the form:
> 
> Fixes: $(SHA1) ("header text of commit message")
> 
> The SHA1 ID should be reduced to 12 digits of significance.

Ok, will post V2.

