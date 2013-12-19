Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3LSOEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:04:42 -0500
Received: from mail.southpole.se ([37.247.8.11]:46117 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab3LSOEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:04:40 -0500
Message-ID: <52B2FCF5.40601@southpole.se>
Date: Thu, 19 Dec 2013 15:04:37 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: Lockdep warning
References: <52B2F668.2030400@southpole.se> <20131219140221.GA27143@pd.tnic>
In-Reply-To: <20131219140221.GA27143@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13335) on assp.southpole.se
X-Assp-ID: assp.southpole.se 61877-08212
X-Assp-Session: 7F3FBC8B7170 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 03:02 PM, Borislav Petkov wrote:
> On Thu, Dec 19, 2013 at 02:36:40PM +0100, Jonas Bonn wrote:
>
> In such situations I'd always search the net first, to see whether this
> has been fixed already. Hint: try searching for "lockdep __udp4_lib_rcv"

Ah... my bad.  Thanks!

Sorry for the noise.

/Jonas
