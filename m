Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182Ab3DEErU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:47:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53410 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3DEErT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:47:19 -0400
Date: Fri, 05 Apr 2013 00:47:15 -0400 (EDT)
Message-Id: <20130405.004715.1638901359632228839.davem@davemloft.net>
To: svenjoac@gmx.de
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dingtianhong@huawei.com, edumazet@google.com
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: David Miller <davem@davemloft.net>
In-Reply-To: <87vc833kpf.fsf@turtle.gmx.de>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 04 Apr 2013 21:47:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Joachim <svenjoac@gmx.de>
Date: Wed, 03 Apr 2013 13:41:32 +0200

> On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> 
>> 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> here, and 65534 is the uid of user "nobody".

Greg and Ben, please stop this patch from all of the -stable trees.

I'm going to revert it and use Eric Biederman's fix instead.

Thanks!
