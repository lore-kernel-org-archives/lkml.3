Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKXVLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:11:47 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44435 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaKXVLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:11:44 -0500
Message-ID: <54739F0C.7040802@cogentembedded.com>
Date: Tue, 25 Nov 2014 00:11:40 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ARM: shmobile: kzm9g-reference dts: Move Ethernet
 node to BSC
References: <1416859808-18503-1-git-send-email-geert+renesas@glider.be> <1416859808-18503-3-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1416859808-18503-3-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/24/2014 11:10 PM, Geert Uytterhoeven wrote:

> Move the Ethernet node from the root of the device tree to the BSC node,
> as it is connected to the Bus State Controller.  This allows the system
> to know the right position of the Ethernet node in the clock and PM
> domain hierarchy.

> Also rename the node's name from "lan9220" to "ethernet", to confirm to

    s/confirm/comply/, you mean?

> ePAPR generic name recomendations.

    Thank you, I've never found the time to rename those device nodes.

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

WBR, Sergei

