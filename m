Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaACTkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:40:12 -0500
Received: from vhex.net ([146.185.136.158]:36244 "EHLO vhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaACTkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:40:11 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jan 2014 14:40:11 EST
Message-ID: <52C710CE.1090302@vhex.net>
Date: Fri, 03 Jan 2014 20:34:38 +0100
From: art1 <art1@vhex.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Oliver Neukum <oneukum@suse.de>,
        dashing.meng@gmail.com, Niklas Schnelle <niklas@komani.de>,
        Giorgos <ganastasiouGR@gmail.com>
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
References: <52B31EDA.60908@compulab.co.il> <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos> <52B41EC7.1070704@compulab.co.il> <20131220234547.GC2835@xanatos> <52B69925.8030409@compulab.co.il> <20140103000334.GE9621@xanatos>
In-Reply-To: <20140103000334.GE9621@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 01:03 AM, Sarah Sharp wrote:
> ISTR that the other folks on Cc (Meng, Niklas, Giorgos, and Art) all 
> had systems that broke when commit 
> 638298dc66ea36623dbc2757a24fc2c4ab41b016 was introduced. For those 
> systems, what vendor was the system, and what BIOS was it running?
Information from dmidecode:

BIOS Information
         Vendor: American Megatrends Inc.

System Information
         Manufacturer: To Be Filled By O.E.M.
         Product Name: To Be Filled By O.E.M.
         Version: To Be Filled By O.E.M.

Base Board Information
         Manufacturer: ASRock
         Product Name: B85 Pro4

