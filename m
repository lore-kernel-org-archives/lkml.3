Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaAMXnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:43:22 -0500
Received: from top.free-electrons.com ([176.31.233.9]:36274 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbaAMXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:43:18 -0500
Message-ID: <52D47A12.7000807@free-electrons.com>
Date: Tue, 14 Jan 2014 00:43:14 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] iio: mxs-lradc: fix invalid channel number detection
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com> <1389628923-8689-3-git-send-email-alexandre.belloni@free-electrons.com> <201401132125.37243.marex@denx.de>
In-Reply-To: <201401132125.37243.marex@denx.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/2014 21:25, Marek Vasut wrote:
> On Monday, January 13, 2014 at 05:02:02 PM, Alexandre Belloni wrote:
>> 16 would be accepted as a channel number but it is invalid. It doesn't
>> really have any effect as mxs_lradc_read_raw is called from a "controlled"
>> environment so it it only gets values going from 0 to 15.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Why don't you remove the check entirely then ?
> 

I'm not quite sure the inkernel API is sanitizing the input correctly
but maybe I didn't check enough. Maybe Jonathan can comment ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
