Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaDUTpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:45:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41274 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaDUTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:45:15 -0400
Message-ID: <535573D5.9050805@wwwdotorg.org>
Date: Mon, 21 Apr 2014 13:39:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>
CC: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V6] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
References: <20140417060644.27329.31663.stgit@yunodevel>
In-Reply-To: <20140417060644.27329.31663.stgit@yunodevel>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 12:06 AM, Yoshihiro YUNOMAE wrote:
> Add tunable RX interrupt trigger I/F of FIFO buffers.
> Serial devices are used as not only message communication devices but control
> or sending communication devices. For the latter uses, normally small data
> will be exchanged, so user applications want to receive data unit as soon as
> possible for real-time tendency. If we have a sensor which sends a 1 byte data
> each time and must control a device based on the sensor feedback, the RX
> interrupt should be triggered for each data.
> 
> According to HW specification of serial UART devices, RX interrupt trigger
> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
> the trigger to only 8bytes.
> 
> This patch makes some devices change RX interrupt trigger from userland.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
