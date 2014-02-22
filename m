Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBVXSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:18:49 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:10284 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaBVXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:18:46 -0500
X-IronPort-AV: E=Sophos;i="4.97,526,1389744000"; 
   d="scan'208";a="103288006"
Message-ID: <53093051.9040907@citrix.com>
Date: Sat, 22 Feb 2014 23:18:41 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 4/9] xen-netback: Change RX path for mapped
 SKB fragments
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>	 <1390253069-25507-5-git-send-email-zoltan.kiss@citrix.com> <1392745532.23084.65.camel@kazak.uk.xensource.com>
In-Reply-To: <1392745532.23084.65.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.49]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/14 17:45, Ian Campbell wrote:
> On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
>
> Re the Subject: change how? Perhaps "handle foreign mapped pages on the
> guest RX path" would be clearer.
Ok, I'll do that.

>
>> RX path need to know if the SKB fragments are stored on pages from another
>> domain.
> Does this not need to be done either before the mapping change or at the
> same time? -- otherwise you have a window of a couple of commits where
> things are broken, breaking bisectability.
I can move this to the beginning, to keep bisectability. I've put it 
here originally because none of these makes sense without the previous 
patches.

Zoli
