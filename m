Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaFPILw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:11:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44981 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaFPILv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:11:51 -0400
Date: Mon, 16 Jun 2014 01:11:48 -0700 (PDT)
Message-Id: <20140616.011148.2001285440663327901.davem@davemloft.net>
To: mprivozn@redhat.com
Cc: jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed only when possible
From: David Miller <davem@davemloft.net>
In-Reply-To: <539E9D93.9040405@redhat.com>
References: <539AC237.40402@redhat.com>
	<20140613.130350.1729507484821351177.davem@davemloft.net>
	<539E9D93.9040405@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Jun 2014 01:11:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Privoznik <mprivozn@redhat.com>
Date: Mon, 16 Jun 2014 09:32:35 +0200

> On 13.06.2014 22:03, David Miller wrote:
>> From: Michal Privoznik <mprivozn@redhat.com>
>> Date: Fri, 13 Jun 2014 11:19:51 +0200
>>
>>> So if I were developing brand new application I could say: I'm
>>> dropping all this workaround code and have it clean and require say
>>> 3.16 kernel at least.
>>
>> Then your application wouldn't be usable on %99 of systems for a long
>> long time.
>>
> 
> How come? The application is going to be usable for as long as
> library/kernel APIs won't change.

Because %99 of users are using a distribution kernel which is definitely
going to be pre-3.16 for years.

