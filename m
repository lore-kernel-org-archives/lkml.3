Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab3CZKfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:35:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3CZKfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:35:23 -0400
Message-ID: <515179E6.4020709@free-electrons.com>
Date: Tue, 26 Mar 2013 11:35:18 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-serial@vger.kernel.org,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: add support for clk api
References: <1363689316-7847-2-git-send-email-maxime.ripard@free-electrons.com> <1363690369-8067-1-git-send-email-maxime.ripard@free-electrons.com> <20130321084707.GB2862@xps8300>
In-Reply-To: <20130321084707.GB2862@xps8300>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Le 21/03/2013 09:47, Heikki Krogerus a écrit :
> On Tue, Mar 19, 2013 at 11:52:49AM +0100, Maxime Ripard wrote:
>> From: Emilio López <emilio@elopez.com.ar>
>>
>> This commit implements support for using the clk api; this lets us use
>> the "clocks" property with device tree, instead of having to use
>> clock-frequency.
>>
>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> 
> FWIW,
> 
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Would you consider merging this patch, or do you have additional comments?

We have several patch series that depends on this one that I'd like to
see included in 3.10, and we begin to see the end of the 3.9 release cycle.

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
