Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3GTMyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:54:45 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:35999 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456Ab3GTMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:54:43 -0400
Message-ID: <51EA8893.4060602@metafoo.de>
Date: Sat, 20 Jul 2013 14:54:43 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: Jonathan Cameron <jic23@kernel.org>, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: Re: [PATCH 00/15] iio: ti_am335x_adc: Add continuous mode take 2
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com> <51EA73BC.8050901@kernel.org> <20130720124731.GA10834@gmail.com>
In-Reply-To: <20130720124731.GA10834@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 02:47 PM, Zubair Lutfullah : wrote:
> On Sat, Jul 20, 2013 at 12:25:48PM +0100, Jonathan Cameron wrote:
>> I am a little irritated by the mess we have here.  Russ has clearly done
>> a lot of fine work cleaning up the earlier patches.  As a result
>> we have a series of initial buggy patches and then a series of patches
>> fixing them again.
>
> Indeed.
>
> I had already merged a lot of minor bug fixes from Rachil into the main
> patch that adds continuous mode.
>
> But I kept Russ's ones separate because of authorship and history.

It's ok to merge the patches if you add a note to the commit messages saying 
what aspects you fixed. There is no need to add patches to the git tree that we 
know of that they are broken.

- Lars

