Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3DYBGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 21:06:42 -0400
Received: from intranet.asianux.com ([58.214.24.6]:18959 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab3DYBGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 21:06:41 -0400
X-Spam-Score: -100.8
Message-ID: <5178816D.3000309@asianux.com>
Date: Thu, 25 Apr 2013 09:05:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike <qiudayu@linux.vnet.ibm.com>
CC: Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com>  <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com>  <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost>
In-Reply-To: <1366807638.5911.2.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月24日 20:47, Mike wrote:
> 在 2013-04-24三的 20:37 +1000，Michael Neuling写道：
>> > Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
>> > 
>>> > > 于 2013/4/24 16:31, Michael Ellerman 写道:
>>>> > > > On Wed, Apr 24, 2013 at 04:22:53PM +0800, Mike Qiu wrote:
>>>>> > > >> Hi all
>>>>> > > >>
>>>>> > > >> I get an error message when I compile the source code in Power7 platform
>>>>> > > >> use the newest upstream kernel.
>>>> > > > Hi Mike,
>>>> > > >
>>>> > > > It depends on what your .config is. What defconfig are you building?
>>> > > I just copy the config file from /boot/config.* to .config and use make
>>> > > menuconfig
>>> > > change nothing by manually, then save.
>> > 
>> > Can you post the resulting config here?
>> > 
>> > Do you have commit in your tree?
>> >   commit 087aa036eb79f24b856893190359ba812b460f45
>> >   Author: Chen Gang <gang.chen@asianux.com>
>> >   powerpc: make additional room in exception vector area
>> > 
> Sure, that commit certainly in my git tree. And I just try to remove the
> code and re-git clone the source code from upstream, this problem still
> happen.
> I will post the config file as the attachment
> :)
> 
> Thanks

I will try, and plan to get a result within this week (2013-04-28)

Thanks.

-- 
Chen Gang

Asianux Corporation
