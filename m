Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbaJaSFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:05:11 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43171 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbaJaSFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:05:09 -0400
X-Greylist: delayed 1589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 14:05:09 EDT
Message-ID: <5453CF52.3030303@hurleysoftware.com>
Date: Fri, 31 Oct 2014 14:05:06 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, Udo van den Heuvel <udovdh@xs4all.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: 3.17.2. issue?
References: <5453AE33.8040802@xs4all.nl> <5453C91D.9060702@hurleysoftware.com> <5453CB40.8040303@xs4all.nl>
In-Reply-To: <5453CB40.8040303@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 01:47 PM, Hans Verkuil wrote:
> On 10/31/2014 06:38 PM, Peter Hurley wrote:
>> [ +cc Hans Verkuil, Mauro Carvalho Chehab, linux-media ]
> 
> Fixed by this patch: https://patchwork.linuxtv.org/patch/26302/
> 
> Which is queued for 3.18. I think this should be backported
> to 3.17 as well.

Thanks for the quick response, Hans.

I'm sure Udo does/will appreciate it.

Regards,
Peter Hurley
