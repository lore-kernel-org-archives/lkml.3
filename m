Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbaC0PRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:17:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10382 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbaC0PRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:17:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,743,1389744000"; 
   d="scan'208";a="115485402"
Message-ID: <533440EA.20608@citrix.com>
Date: Thu, 27 Mar 2014 15:16:58 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next] xen-netback: Grant copy the header instead of
 map and memcpy
References: <1395868707-22683-1-git-send-email-zoltan.kiss@citrix.com> <1395920136.22909.76.camel@kazak.uk.xensource.com> <53341DA8.9010102@citrix.com>
In-Reply-To: <53341DA8.9010102@citrix.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/14 12:46, Zoltan Kiss wrote:
> On 27/03/14 11:35, Ian Campbell wrote:
>> On Wed, 2014-03-26 at 21:18 +0000, Zoltan Kiss wrote:
>> You've added a second hypercall to tx_action, probably those can be
>> combined into one vm exit by using a multicall.
> Yes, good idea!

Thinking a bit further, it would need some grant-table.c changes first. 
I've put it onto my todo list.

Zoli
