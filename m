Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbaEMJqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:46:49 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46650 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbaEMJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:46:45 -0400
Message-ID: <5371EA01.3080307@gmail.com>
Date: Tue, 13 May 2014 11:46:41 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
CC: balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1399969905-3509-1-git-send-email-george.cherian@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 05/13/2014 10:31 AM, George Cherian wrote:
> Series add support for SW babble control logic found in 
> new silicon versions of AM335x. Runtime differentiation of
> silicon version is done by checking the BABBLE_CTL register.
> For newer silicon the register default value read is 0x4 and
> for older versions its 0x0.

I tested this on a AM33xx platform and don't see any regression at
least. This hardware has MUSB_BABBLE_CTL == MUSB_BABBLE_RCV_DISABLE.
Anything particular you want me to test as well?


Thanks,
Daniel

