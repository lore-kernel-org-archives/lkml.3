Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbbAOPcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:32:46 -0500
Received: from skprod2.natinst.com ([130.164.80.23]:56901 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753555AbbAOPcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:32:43 -0500
Message-ID: <54B7DD93.8000104@ni.com>
Date: Thu, 15 Jan 2015 09:32:35 -0600
From: Xander Huff <xander.huff@ni.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, davem@davemloft.net
CC: netdev@vger.kernel.org, jaeden.amero@ni.com, rich.tollerton@ni.com,
        ben.shelton@ni.com, brad.mouring@ni.com, linux-kernel@vger.kernel.org,
        cyrille.pitchen@atmel.com
Subject: Re: [PATCH v2 2/2] fixup! net/macb: improved ethtool statistics support
References: <20150114.165220.2282566005036464131.davem@davemloft.net> <1421274051-21588-1-git-send-email-xander.huff@ni.com> <1421274051-21588-2-git-send-email-xander.huff@ni.com> <54B797E5.6070503@atmel.com>
In-Reply-To: <54B797E5.6070503@atmel.com>
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/15/2015 09:32:35 AM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/15/2015 09:32:36 AM,
	Serialize complete at 01/15/2015 09:32:36 AM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=windows-1252; format=flowed
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-15_06:2015-01-15,2015-01-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/2015 4:35 AM, Nicolas Ferre wrote:
>>   #define GEM_OTX					0x0100 /* Octets transmitted */
> I see, it's modified hereafter! Why not integrate this part in previous
> patch?
>
>

I split these up the way I did by using the --fixup argument to allow the rebase 
--autosquash to work. I could instead have a series of fixup commits to fix each 
type of style issue and then also the functional issue if you'd prefer, but 
--autosquash will no longer work.
