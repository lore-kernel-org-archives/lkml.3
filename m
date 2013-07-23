Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137Ab3GWWkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:40:10 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:47757 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934564Ab3GWWkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:40:06 -0400
Message-ID: <51EF0643.5030507@tilera.com>
Date: Tue, 23 Jul 2013 18:40:03 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jianpeng Ma <majianpeng@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mvsas: fix unaligned-access kernel panic under heavy
 disk testing
References: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com>  <1374613204.2290.49.camel@dabdike> <51EEF2DA.3070903@tilera.com> <1374618791.2290.53.camel@dabdike>
In-Reply-To: <1374618791.2290.53.camel@dabdike>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/2013 6:33 PM, James Bottomley wrote:
> On Tue, 2013-07-23 at 17:17 -0400, Chris Metcalf wrote:
>> On 7/23/2013 5:00 PM, James Bottomley wrote:
>>> On Tue, 2013-07-23 at 16:50 -0400, Chris Metcalf wrote:
>>>>> The slot->response value may not be aligned, so should be read
>>>>> using the appropriate kernel "unaligned" accessor.
>>> Hm, institutional memory re-presenting the wrong patch?  However, I am
>>> reminded to push the right one in spite of no ack from marvell.
>> You may be right; the original author of that patch is not me, but someone else here at Tilera.
>>
>> That said, the version I pushed is effectively the version we have in the tip of our tree, so if we've ended up carrying the wrong patch, that's bad!  Let me know what the right patch is that you have - thanks.
> This is what I have.

Thanks, I've merged the optimization back into our tree :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

