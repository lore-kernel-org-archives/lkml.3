Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab3E1P6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:58:17 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63055 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550Ab3E1P6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:58:15 -0400
Message-ID: <51A4D410.6030307@gmail.com>
Date: Tue, 28 May 2013 17:58:08 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130528154047.GT31290@titan.lakedaemon.net> <20130528175343.77c6353d@skate>
In-Reply-To: <20130528175343.77c6353d@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/13 17:53, Thomas Petazzoni wrote:
> On Tue, 28 May 2013 11:40:47 -0400, Jason Cooper wrote:
>> I'm posting the revised version as replies to patches 1, 5 and 6. Please
>> let me know if I messed it up.  I'd like to send the PR for these
>> shortly.
>
> I had a quick look, and it looks good to me. Let me know to which
> branch you've pushed this, and the merge order to follow to "rebuild"
> something that works, and I'll try to find some time to test it for
> real on hardware.

I also had a visual check of the files, especially clock_gating_descr.
Didn't find a typo. I will also compile and run on Dove and Kirkwood,
but I guess it should be fine.

Thanks for the effort!

Sebastian

