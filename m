Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3JHOwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:52:04 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.209]:61381 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190Ab3JHOwB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:52:01 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 10:52:01 EDT
X-Env-Sender: peter.korsgaard@barco.com
X-Msg-Ref: server-16.tower-45.messagelabs.com!1381243536!28382190!3
X-Originating-IP: [91.183.172.68]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: Peter Korsgaard <peter.korsgaard@barco.com>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use deferred probing with the device tree
References: <52540DF6.6050407@nsn.com>
X-message-flag: thor uptime: 538 days, 17:50,  7 users
Date: Tue, 8 Oct 2013 16:45:09 +0200
In-Reply-To: <52540DF6.6050407@nsn.com> (Ionut Nicu's message of "Tue, 8 Oct
	2013 15:51:50 +0200")
Message-ID: <87bo2zn7nu.fsf@thor.barco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "IN" == Ionut Nicu <ioan.nicu.ext@nsn.com> writes:

IN> If the i2c-parent bus driver is not loaded, returning
IN> -EINVAL will force people to unload and then reload the
IN> module again to get it working.

IN> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>

--
Sorry about disclaimer - It's out of my control.
Bye, Peter Korsgaard
This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
