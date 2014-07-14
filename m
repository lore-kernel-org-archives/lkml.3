Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaGNNhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:37:10 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43772 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaGNNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:37:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jul 2014 15:37:02 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] can: flexcan: add vf610 support for FlexCAN
In-Reply-To: <53C38FD9.8070403@pengutronix.de>
References: <cover.1405322992.git.stefan@agner.ch>
 <3b047f9eb64ef01a958d83706af8f7e973358420.1405322992.git.stefan@agner.ch>
 <53C38FD9.8070403@pengutronix.de>
Message-ID: <5b42e19c9741a0b54420ade131f84408@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-14 10:07, schrieb Marc Kleine-Budde:
<snip>
>> +	/*
>> +	 * On Vybrid, disable memory error detection interrupts
>> +	 * and freeze mode.
>> +	 * This also works around errata e5295 which generates
>> +	 * false positive memory errors and put the device in
>> +	 * freeze mode.
>> +	 */
>> +	if (priv->devtype_data->features & FLEXCAN_HAS_MECR_FEATURES) {
>> +		/*
>> +		 * Follow the protocol as described in "Detection
>> +		 * and Correction of Memory Errors" to write to
>> +		 * MECR register
>> +		 */
> 
> 
> One nitpick regarding the comment. In driver/net, the preferred
> multi-line comment style is
> 

Just a few lines above that one, another multi-line comment is written
with the empty line at start... With this changed to the net comment
style, we would end up in a mixed style... What do you think?

--
Stefan
