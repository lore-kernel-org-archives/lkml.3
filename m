Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaIMTcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:32:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37455 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaIMTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:32:16 -0400
Date: Sat, 13 Sep 2014 15:32:14 -0400 (EDT)
Message-Id: <20140913.153214.322363335285385219.davem@davemloft.net>
To: shakilk1729@gmail.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH] Freeing dst when the reference count <0 causes general
 protection fault, it could be a major security flaw as rogue app can
 modify dst to crash kernel.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGiEYNd7HEURq0vSh+MgmzG-jyWLF_8UcnbO7EeNMS_vznyX6g@mail.gmail.com>
References: <1410596833-2548-1-git-send-email-shakilk1729@gmail.com>
	<1410609022.7106.132.camel@edumazet-glaptop2.roam.corp.google.com>
	<CAGiEYNd7HEURq0vSh+MgmzG-jyWLF_8UcnbO7EeNMS_vznyX6g@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Sep 2014 12:32:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shakil k <shakilk1729@gmail.com>
Date: Sat, 13 Sep 2014 10:46:39 -0700

> On Sat, Sep 13, 2014 at 4:50 AM, Eric Dumazet <eric.dumazet@gmail.com>
> wrote:
> 
>> Can you describe how this could trigger with a pristine kernel ?
>> This can be reproduced with our custom network traffic to simulate malware.
>>
> Point is the user can modify certain packets and can cause a kernel crash
> causing blackout to all the linux boxes hosting services :(

Eric is kindly asking you exactly how to reproduce the crash, so he
can 1) fix it and 2) generate a test case that gets run all the time
in the future.

Please answer his question directly instead of steering the conversation
endless towards other aspects.
