Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3DXBM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:12:57 -0400
Received: from intranet.asianux.com ([58.214.24.6]:11079 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3DXBM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:12:56 -0400
X-Spam-Score: -100.8
Message-ID: <51773169.9020607@asianux.com>
Date: Wed, 24 Apr 2013 09:12:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: jason.wessel@windriver.com, sasha.levin@oracle.com,
        vincent.stehle@laposte.net, john.blackwood@ccur.com,
        kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: debug: kdb: strncpy issue, using strlcpy instead
 of strncpy.
References: <5161526F.8070306@asianux.com> <516E6EB1.70100@asianux.com> <20130423205011.GA5915@teo>
In-Reply-To: <20130423205011.GA5915@teo>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013Äê04ÔÂ24ÈÕ 04:50, Anton Vorontsov wrote:
> On Wed, Apr 17, 2013 at 05:43:13PM +0800, Chen Gang wrote:
>> > Hello maintainers:
>> > 
>> >   please help check this patch, when you have time, thanks.
>> > 
> The patch looks good. I would add to the description: "..., otherwise the
> destination string might end up not being terminted with the NUL, causing
> all sorts of misbehaviour."
> 
> 	Acked-by: Anton Vorontsov <anton@enomsg.org>
> 
> Thanks!
> 

Thanks, also thank you for your additional description.

-- 
Chen Gang

Asianux Corporation
