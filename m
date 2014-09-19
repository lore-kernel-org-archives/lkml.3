Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaISLfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:35:13 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:38157 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756050AbaISLfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:35:06 -0400
Message-ID: <541C14E7.8020208@nexus-software.ie>
Date: Fri, 19 Sep 2014 12:35:03 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, "Chew, Kean Ho" <kean.ho.chew@intel.com>
Subject: Re: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
References: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie> <20140919105833.GB31784@xps8300>
In-Reply-To: <20140919105833.GB31784@xps8300>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/14 11:58, Heikki Krogerus wrote:
> On Fri, Sep 19, 2014 at 08:43:49AM +0100, Bryan O'Donoghue wrote:
>> Adds PCI identifier for the X1000
>> Adds clocking and register size and register shift
>>
>> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
>> ---
>>   drivers/tty/serial/8250/8250_pci.c | 33 +++++++++++++++++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>
> The UART on Quark SoC has an integrated DMA engine and Kean Ho (CC'd)
> is working with support for it. The plan is to add completely separate
> probe driver for the Quark UART. Dealing with the integrated DMA
> engine is too much for a quirk in 8250_pci.c.
>
> So we can take this now and when Kean Ho is ready he needs to
> basically revert it, or you could already introduce the new probe
> driver, 8250_quark.c, and Kean Ho can then add the DMA engine handling
> later to it.
>
> IMO we should add the 8250_quark.c already now.

Sounds great - is the 8250_quark.c code ready ?

If so then fantastic I agree with you.

If not then, lets do as you suggest Heikki and apply the simple patch 
above in the interim.


Best,
BOD


