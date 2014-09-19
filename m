Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaISNZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:25:45 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:33074 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaISNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:25:43 -0400
Message-ID: <541C2ED3.7080206@nexus-software.ie>
Date: Fri, 19 Sep 2014 14:25:39 +0100
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
References: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie> <20140919105833.GB31784@xps8300> <541C14E7.8020208@nexus-software.ie> <1E478852902BF549B22CC4F16C2AE67C0F472359@PGSMSX108.gar.corp.intel.com> <541C295A.6020101@nexus-software.ie> <1E478852902BF549B22CC4F16C2AE67C0F47241C@PGSMSX108.gar.corp.intel.com>
In-Reply-To: <1E478852902BF549B22CC4F16C2AE67C0F47241C@PGSMSX108.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/14 14:10, Chew, Kean Ho wrote:
>> Can you submit that soon
> Will do.
>
Hi Ho.

Do you have an idea when ?

I guess if we're saying the simple patch which works right now - should 
be rejected in favour of alternative code coming - then at a minimum 
could you please give an indication of when that alternative code will 
be available ?

Otherwise I think it makes sense to enable the hardware now - using the 
bog-standard means of doing that - just like BYT and others :)

-- 
BOD
