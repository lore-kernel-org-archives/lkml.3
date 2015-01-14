Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbANVSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:18:39 -0500
Received: from skprod3.natinst.com ([130.164.80.24]:54236 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbbANVSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:18:37 -0500
Message-ID: <54B6DD2A.1050502@ni.com>
Date: Wed, 14 Jan 2015 15:18:34 -0600
From: Xander Huff <xander.huff@ni.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nicolas.ferre@atmel.com, netdev@vger.kernel.org, jaeden.amero@ni.com,
        rich.tollerton@ni.com, ben.shelton@ni.com, brad.mouring@ni.com,
        linux-kernel@vger.kernel.org, cyrille.pitchen@atmel.com
Subject: Re: [PATCH 1/2] fixup! net/macb: Adding comments to various #defs
 to make interpretation easier
References: <54B690F5.5080308@atmel.com>	<1421266881-17314-1-git-send-email-xander.huff@ni.com> <20150114.160929.619787519481343067.davem@davemloft.net>
In-Reply-To: <20150114.160929.619787519481343067.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/14/2015 03:18:35 PM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/14/2015 03:18:35 PM,
	Serialize complete at 01/14/2015 03:18:35 PM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=windows-1252; format=flowed
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_07:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/2015 3:09 PM, David Miller wrote:
>
> As I mentioned, this won't do.
>
> I've already applied your original patches to net-next, therefore you will
> have to submit fixups relative to that.
>
These fixup commits are relative to an updated net-next, specifically "237de6e 
Merge branch 'hip04'".

Do you need them relative to (what I'm seeing is the latest) "2733135 Merge 
branch 'vxlan_rco'"?
