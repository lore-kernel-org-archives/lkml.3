Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3JHNfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:35:06 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:10310 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3JHNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:35:04 -0400
Message-ID: <52540A00.9030505@nsn.com>
Date: Tue, 08 Oct 2013 15:34:56 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-gpio: use deferred probing with the device tree
References: <52540692.9080208@nsn.com> <87ob6znb3q.fsf@thor.barco.com>
In-Reply-To: <87ob6znb3q.fsf@thor.barco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 666
X-purgate-ID: 151667::1381239298-00005753-FE00D337/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.2013 15:30, ext Peter Korsgaard wrote:
>>>>>> "IN" == Ionut Nicu <ioan.nicu.ext@nsn.com> writes:
> 
> IN> If the i2c-parent bus driver is not loaded, returning
> IN> -EINVAL will force people to unload and then reload the
> IN> module again to get it working.
> 
> IN> Also of_get_named_gpio could return -E_PROBE_DEFER or
> IN> another error code. This error should be passed further
> IN> instead of being ignored.
> 
> Two different fixes, so should be 2 separate patches. Other that that,
> it looks good.
> 
> Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>
> 

Right, I will split it into two patches and re-submit.

Thanks!
