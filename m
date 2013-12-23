Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3LWQcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:32:35 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:49463 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932281Ab3LWQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:32:31 -0500
From: Iyappan Subramanian <isubramanian@apm.com>
References: <1387597376-29303-1-git-send-email-isubramanian@apm.com> <201312221035.44961.arnd@arndb.de>
In-Reply-To: <201312221035.44961.arnd@arndb.de>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac7++UUak79dqYg6SRmrhSrLwXjPGQBAxOdQ
Date: Mon, 23 Dec 2013 08:32:28 -0800
Message-ID: <1dd2a889f23c7003b11044665329f174@mail.gmail.com>
Subject: RE: [PATCH 0/5] drivers: net: Adding support for APM X-Gene SoC
 Ethernet base driver
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: davem@davemloft.net, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, patches <patches@apm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jcm@redhat.com,
        Keyur Chudgar <kchudgar@apm.com>, Ravi Patel <rapatel@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes.  My third patch didn't make it to the linux-arm-kernel mailing list
due to size.  I am waiting for the moderator's approval to get it posted.

Thanks,
Iyappan

Your mail to 'linux-arm-kernel' with the subject

    [PATCH 3/5] drivers: net: APM X-Gene SoC Ethernet base driver

Is being held until the list moderator can review it for approval.

The reason it is being held:

    Message body is too big: 112640 bytes with a limit of 100 KB

Either the message will get posted to the list, or you will receive
notification of the moderator's decision.  If you would like to cancel
this posting, please visit the following URL:


http://lists.infradead.org/mailman/confirm/linux-arm-kernel/0aca8492f9ca29
055149ebf4058771fd701fd928


-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Sunday, December 22, 2013 1:36 AM
To: linux-arm-kernel@lists.infradead.org
Cc: Iyappan Subramanian; davem@davemloft.net; devicetree@vger.kernel.org;
gregkh@linuxfoundation.org; patches@apm.com; linux-kernel@vger.kernel.org;
netdev@vger.kernel.org; jcm@redhat.com; Keyur Chudgar; Ravi Patel
Subject: Re: [PATCH 0/5] drivers: net: Adding support for APM X-Gene SoC
Ethernet base driver

On Saturday 21 December 2013, Iyappan Subramanian wrote:
> Iyappan Subramanian (5):
>   Documentation: APM X-Gene SoC Ethernet DTS binding documentation
>   arm64: dts: APM X-Gene SoC Ethernet device tree nodes
>   drivers: net: APM X-Gene SoC Ethernet base driver
>   drivers: net: APM X-Gene SoC Ethernet driver error handling
>   drivers: net: APM X-Gene SoC Ethernet driver ethtool support

The third patch (the actual driver) didn't make it to the ARM mailing
list.
Maybe it's too large?

	Arnd
