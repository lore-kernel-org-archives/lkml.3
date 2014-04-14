Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaDNR7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:59:21 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57238 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaDNR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:59:20 -0400
Message-ID: <534C2247.80804@kernel.org>
Date: Mon, 14 Apr 2014 19:00:39 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Pull request ?
References: <20140414081905.GJ2967@piout.net>
In-Reply-To: <20140414081905.GJ2967@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/14 09:19, Alexandre Belloni wrote:
> Hi Jonathan,
>
> I realise you didn't send any pull request for 3.15 yet, do you intend
> to send it soon. As you know, I have a patch set depending on a few
> patches and I'd like to rebase and resend it soon.
>
> Regards,
>
Hi Alexandre.

All my patches are still routed via pull requests to Greg KH. That tends to
mean that the IIO merge window closes a few weeks before Linus' opens.

Anything going out now (other than fixes) will be 3.16 material.
Now 3.15-rc1 is out I'll do a pull request to Greg sometime in the next
couple of days.  That way we get stuff into Linux next asap.

Jonathan
