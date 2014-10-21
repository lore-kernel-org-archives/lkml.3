Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbaJUVYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:24:09 -0400
Received: from down.free-electrons.com ([37.187.137.238]:51879 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933376AbaJUVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:24:07 -0400
Message-ID: <5446CE9B.1060907@free-electrons.com>
Date: Tue, 21 Oct 2014 18:22:35 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Grzegorz Jaszczyk <jaz@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tglx@linutronix.de,
        gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com
Subject: Re: [PATCH 0/2] Marvell Armada 375/38x MPIC/MSI fixes
References: <1411643839-64925-1-git-send-email-jaz@semihalf.com> <20141003135017.GH3895@titan.lakedaemon.net> <54466B73.3090704@free-electrons.com> <20141021151415.GU17447@titan.lakedaemon.net>
In-Reply-To: <20141021151415.GU17447@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 12:14 PM, Jason Cooper wrote:
[..]
> 
>> Since this is an important fix, maybe you can schedule it for -rc2?
> 
> I have.  For some reason I have yet to delve into, there were no
> linux-next's during the merge window.  As a result, yesterday's -next
> was the first for the two patches in question.  I'd like to get them
> pushed for -rc2, so I'll probably send the PR tomorrow to get one more
> day in -next.
> 

Great, thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
