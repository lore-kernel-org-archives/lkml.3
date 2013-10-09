Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3JIKOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:14:18 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.6]:26279 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab3JIKOR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:14:17 -0400
X-Env-Sender: peter.korsgaard@barco.com
X-Msg-Ref: server-16.tower-29.messagelabs.com!1381313654!23493211!1
X-Originating-IP: [91.183.172.68]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: Peter Korsgaard <peter.korsgaard@barco.com>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use deferred probing
References: <525526F5.5030107@nsn.com>
X-message-flag: thor uptime: 539 days, 13:19, 10 users
Date: Wed, 9 Oct 2013 12:14:13 +0200
In-Reply-To: <525526F5.5030107@nsn.com> (Ionut Nicu's message of "Wed, 9 Oct
	2013 11:50:45 +0200")
Message-ID: <87mwmilpje.fsf@thor.barco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "IN" == Ionut Nicu <ioan.nicu.ext@nsn.com> writes:

IN> If the i2c-parent bus driver is not loaded, returning
IN> -ENODEV will force people to unload and then reload the
IN> module again to get it working.

IN> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>

--
Sorry about disclaimer - It's out of my control.
Bye, Peter Korsgaard
This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
