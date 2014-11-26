Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaKZO0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:26:03 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:46175 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaKZO0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:26:00 -0500
Message-ID: <5475E2F4.7090603@hurleysoftware.com>
Date: Wed, 26 Nov 2014 09:25:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, gregkh@linuxfoundation.org
CC: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty, serial, 8250: remove __init from function serial8250_console_setup()
References: <20141125175121.GA32573@kroah.com> <1416954082-1755-1-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1416954082-1755-1-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 05:21 PM, Arianna Avanzini wrote:
> Some RS232 adapters handled by this driver are hotpluggable. The function
> serial8250_console_setup() is called during device init and is defined with
> the __init macro. In case the driver is built-in, hotplugging the device after
> the initialization phase has been completed (and the related memory has been
> freed) results in a kernel crash.
> This commit fixes the issue by removing __init from the function definition.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>


