Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaGLCjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:39:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaGLCjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:39:53 -0400
Message-ID: <53C09FF6.8020507@infradead.org>
Date: Fri, 11 Jul 2014 19:39:50 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] serial: imx: Fix build breakage
References: <20140711112108.7631911b@canb.auug.org.au> <1405046206-14495-1-git-send-email-peter@hurleysoftware.com> <20140712004248.GA24760@kroah.com> <53C096D0.3000005@infradead.org> <20140712021635.GB17548@kroah.com>
In-Reply-To: <20140712021635.GB17548@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 19:16, Greg Kroah-Hartman wrote:
> On Fri, Jul 11, 2014 at 07:00:48PM -0700, Randy Dunlap wrote:
>> On 07/11/14 17:42, Greg Kroah-Hartman wrote:
>>> On Thu, Jul 10, 2014 at 10:36:46PM -0400, Peter Hurley wrote:
>>>> Fix breakage introduced by
>>>> commit c557d392fbf5badd693ea1946a4317c87a26a716,
>>>> 'serial: Test for no tx data on tx restart'.
>>>>
>>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>>>
>>> You forgot a "Reported-by:" tag.
>>>
>>> I'll go add it...
>>
>> It's not clear to me that Peter forgot it.
> 
> Why?  Stephen pointed out the problem, in a public place, so I gave him
> credit for it.

SubmittingPatches does not give you permission to do that,
but Stephen just did so.


-- 
~Randy
