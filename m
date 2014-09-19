Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaISNC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:02:28 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:41085 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaISNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:02:26 -0400
Message-ID: <541C295A.6020101@nexus-software.ie>
Date: Fri, 19 Sep 2014 14:02:18 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Chew, Kean Ho" <kean.ho.chew@intel.com>,
        "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
References: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie> <20140919105833.GB31784@xps8300> <541C14E7.8020208@nexus-software.ie> <1E478852902BF549B22CC4F16C2AE67C0F472359@PGSMSX108.gar.corp.intel.com>
In-Reply-To: <1E478852902BF549B22CC4F16C2AE67C0F472359@PGSMSX108.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/14 13:06, Chew, Kean Ho wrote:
>>> So we can take this now and when Kean Ho is ready he needs to
>>> basically revert it, or you could already introduce the new probe
>>> driver, 8250_quark.c, and Kean Ho can then add the DMA engine handling
>>> later to it.
>>>
>>> IMO we should add the 8250_quark.c already now.
>> Sounds great - is the 8250_quark.c code ready ?
>
> I'm still working on the DMA portion and requires more time.
> If the DMA section can be replaced by a placeholder, I should be good.

OK so.

Can you submit that soon, or should the simple PCI enabling code to be 
added ?


--
BOD

