Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3JIGOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:14:32 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.103]:16272 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab3JIGO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:14:28 -0400
X-Env-Sender: peter.korsgaard@barco.com
X-Msg-Ref: server-10.tower-200.messagelabs.com!1381299266!11922328!1
X-Originating-IP: [91.183.172.68]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: Peter Korsgaard <peter.korsgaard@barco.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Ionut Nicu <ioan.nicu.ext@nsn.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use deferred probing with the device tree
References: <52540DF6.6050407@nsn.com> <20131008213642.GB29121@katana>
X-message-flag: thor uptime: 539 days,  9:19,  6 users
Date: Wed, 9 Oct 2013 08:14:25 +0200
In-Reply-To: <20131008213642.GB29121@katana> (Wolfram Sang's message of "Tue,
	8 Oct 2013 23:36:43 +0200")
Message-ID: <87vc17km2m.fsf@thor.barco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "WS" == Wolfram Sang <wsa@the-dreams.de> writes:

WS> On Tue, Oct 08, 2013 at 03:51:50PM +0200, Ionut Nicu wrote:
>> If the i2c-parent bus driver is not loaded, returning
>> -EINVAL will force people to unload and then reload the
>> module again to get it working.
>>
>> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

WS> Doesn't the non-DT case need fixing, too?

Arguably yes.

--
Bye, Peter Korsgaard
This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
