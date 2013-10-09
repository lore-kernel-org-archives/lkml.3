Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3JIIbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:31:09 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:12278 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3JIIbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:31:06 -0400
Message-ID: <52551441.4090503@nsn.com>
Date: Wed, 09 Oct 2013 10:30:57 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use deferred probing with the device
 tree
References: <52540DF6.6050407@nsn.com> <20131008213642.GB29121@katana> <87vc17km2m.fsf@thor.barco.com>
In-Reply-To: <87vc17km2m.fsf@thor.barco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 588
X-purgate-ID: 151667::1381307459-00004A43-B5954E64/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.10.2013 08:14, ext Peter Korsgaard wrote:
>>>>>> "WS" == Wolfram Sang <wsa@the-dreams.de> writes:
> 
> WS> On Tue, Oct 08, 2013 at 03:51:50PM +0200, Ionut Nicu wrote:
>>> If the i2c-parent bus driver is not loaded, returning
>>> -EINVAL will force people to unload and then reload the
>>> module again to get it working.
>>>
>>> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
> 
> WS> Doesn't the non-DT case need fixing, too?
> 
> Arguably yes.
> 

Yes, and it's also a one line fix. Should I do it in a separate
patch or should I change this one and resubmit?
