Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3DXIfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:35:34 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38081 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab3DXIf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:35:28 -0400
Message-ID: <51779941.8080403@linux.vnet.ibm.com>
Date: Wed, 24 Apr 2013 16:35:13 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, gang.chen@asianux.com, sfr@canb.auug.org.au,
        mikey@neuling.org, matt@ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia>
In-Reply-To: <20130424083142.GB26834@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042408-1618-0000-0000-000003C1CB77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/4/24 16:31, Michael Ellerman 写道:
> On Wed, Apr 24, 2013 at 04:22:53PM +0800, Mike Qiu wrote:
>> Hi all
>>
>> I get an error message when I compile the source code in Power7 platform
>> use the newest upstream kernel.
> Hi Mike,
>
> It depends on what your .config is. What defconfig are you building?
I just copy the config file from /boot/config.* to .config and use make 
menuconfig
change nothing by manually, then save.
> cheers
>

