Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaLTMcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:32:48 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:51034 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaLTMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:32:45 -0500
Message-ID: <54956C6A.4060703@cogentembedded.com>
Date: Sat, 20 Dec 2014 15:32:42 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, Johan Hovold <johan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] usb: serial: handle -EPROTO quietly in generic_read_bulk
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com> <1419066698-2684-1-git-send-email-jmmahler@gmail.com> <1419066698-2684-2-git-send-email-jmmahler@gmail.com>
In-Reply-To: <1419066698-2684-2-git-send-email-jmmahler@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/20/2014 12:11 PM, Jeremiah Mahler wrote:

> If a USB serial device driver, which is built using the generic serial
> driver, is unplugged while there is an active program using the device,

    Driver is unplugged? :-)

> it will spam the logs with -EPROTO (71) messages as it attempts to
> retry.

> Most serial usb drivers (metro-usb, pl2303, mos7840, ...) only output
> these messages for debugging.  The generic driver treats these as
> errors.

> Change the default output for the generic serial driver from error to
> debug.

> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>

[...]

WBR, Sergei

