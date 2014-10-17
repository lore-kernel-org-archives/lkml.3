Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaJQMqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:46:40 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52255 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753016AbaJQMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:46:38 -0400
Message-ID: <54410FA0.6000903@hurleysoftware.com>
Date: Fri, 17 Oct 2014 08:46:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudhir Sreedharan <ssreedharan@mvista.com>, gregkh@linuxfoundation.org
CC: khilman@kernel.org, linux-serial@vger.kernel.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org, geert@linux-m68k.org
Subject: Re: [PATCH v1] tty: serial: 8250_core: restore the LCR register in
 set_sleep
References: <CAJJ77WsAi5jmnDxY45ipu3a94D6+yoHJNHgExhFsVoirV3NoyQ@mail.gmail.com> <1413549558-24227-1-git-send-email-ssreedharan@mvista.com>
In-Reply-To: <1413549558-24227-1-git-send-email-ssreedharan@mvista.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 08:39 AM, Sudhir Sreedharan wrote:
> In ST16650V2 based serial uarts, while initalizing the PM state,
> LCR registers are being initialized to 0 in serial8250_set_sleep().
> If console port is already initialized and being used, this will
> throws garbage in the console.

Thanks.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>


