Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3FXNyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:54:01 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:59841 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875Ab3FXNyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:54:00 -0400
Message-ID: <51C84F76.5030402@hurleysoftware.com>
Date: Mon, 24 Jun 2013 09:53:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dean Jenkins <Dean_Jenkins@mentor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SLIP: Is there a maintainer for drivers/net/slip/slip.c ?
References: <51C802DA.4080202@mentor.com>
In-Reply-To: <51C802DA.4080202@mentor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:27 AM, Dean Jenkins wrote:
> Hi,
>
> Using the Linux v3.9 tag, I note that
>
> ./scripts/get_maintainer.pl -f drivers/net/slip/slip.c
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)
>
> There seems to be no maintainer for drivers/net/slip/slip.c, is that true ?
>
> I am asking because sl_encaps() and slip_write_wakeup() do not handle error codes from tty->ops->write() and a recursive stack overflow crash can occur if the tty->ops->write() fails to write all the characters. I have some patches to fix this but would like some feedback on an appropriate solution.

SLIP changes would likely go through David Miller <davem@davemloft.net>.
TTY changes would go through Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Regards,
Peter Hurley

