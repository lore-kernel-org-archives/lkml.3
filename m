Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3CSOTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:19:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51641 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3CSOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:19:10 -0400
X-Greylist: delayed 3989 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 10:19:10 EDT
Message-ID: <514873D9.6060704@hitachi.com>
Date: Tue, 19 Mar 2013 23:19:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, thomas.petazzoni@free-electrons.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [BUG][mvebu] mvneta: cannot request irq 25 on openblocks-ax3
References: <51486445.8040506@hitachi.com> <20130319133324.GS13280@titan.lakedaemon.net>
In-Reply-To: <20130319133324.GS13280@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

(2013/03/19 22:33), Jason Cooper wrote:
> On Tue, Mar 19, 2013 at 10:12:37PM +0900, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here I've hit a bug on the recent kernel. As far as I know, this bug
>> exists on 3.9-rc1 too.
>>
>> When I tried the latest mvebu for-next tree
>> (git://git.infradead.org/users/jcooper/linux.git mvebu/for-next),
> 
> FYI: that branch isn't stable, it's used as a merge-test of
> arm-soc/for-next (also not stable) and any branches I am trying to push
> upstream that day.

Thanks! could you tell me which branch is stable?
(however, I'd like to try new fixes/features on my device too :))

> Gregory has a patch in the works for this.  Hopefully he'll submit
> it by the end of the week.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


