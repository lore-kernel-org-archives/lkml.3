Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaHVKgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:36:16 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63910 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbaHVKgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:36:14 -0400
Message-ID: <53F71D1B.8090004@gmail.com>
Date: Fri, 22 Aug 2014 11:36:11 +0100
From: Iain Paton <ipaton0@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
References: <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk> <20140808180900.GG30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int> <53F11FF6.8030303@gmail.com> <CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com> <53F2E89B.80009@gmail.com> <53F5BE3D.5070209@gmail.com> <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
In-Reply-To: <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/14 01:01, Fabio Estevam wrote:
> On Thu, Aug 21, 2014 at 6:39 AM, Iain Paton <ipaton0@gmail.com> wrote:
> 
>> two and a half days of running this against both a sabre-lite and a
>> wandboard quad B1 and I still have no reason to think there's any
>> sort of a problem.
>>
>> Up to now, my testing has been done with my own config, I'll now
>> repeat the whole thing using the config Mattis posted to see if
>> I can reproduce it that way.
>>
>> Suggestions on a better / easier / quicker way to reproduce it are
>> welcome.
> 
> Thanks, Iain.
> 
> Mattis,
> 
> What is the silicon version of the mx6 in your sabrelite? What GCC
> version do you use?
> 

For reference, both my SL and WBQUAD report silicon rev 1.2
The RIoTboard uses a Solo and reports silicon rev 1.1

I'm using vanilla gcc 4.9.1 and compiling the kernel natively on a 
sabre-lite.



