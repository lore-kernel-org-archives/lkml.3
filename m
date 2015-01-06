Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbbAFOCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:02:08 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44008 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbbAFOCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:02:05 -0500
Message-ID: <54ABEAD9.9090200@hurleysoftware.com>
Date: Tue, 06 Jan 2015 09:02:01 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>, gregkh@linuxfoundation.org
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Patch v4] ARC: Dynamically determine BASE_BAUD from DeviceTree
References: <54ABD526.9020907@hurleysoftware.com> <1420552747-27544-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1420552747-27544-1-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 08:59 AM, Vineet Gupta wrote:
> 8250 earlycon is broken on multi-platform ARC because the UART clk
> value (BASE_BAUD) is fixed at build time.
> 
> Instead, determine the appropriate UART clk at runtime; parse the
> devicetree early for platforms requiring alternate UART clk values
> (currently only the TB10X platform).

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

