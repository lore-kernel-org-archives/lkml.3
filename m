Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966492Ab3DQSzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:55:48 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56117 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3DQSzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:55:47 -0400
Message-ID: <516EF026.5000508@gmail.com>
Date: Wed, 17 Apr 2013 14:55:34 -0400
From: Kyle Evans <kvans32@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>    <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>   <51699843.7060905@gmail.com> <1366129583.13667.11.camel@x230.lan>  <516EC19C.3010906@gmail.com> <1366221554.13667.13.camel@x230.lan>
In-Reply-To: <1366221554.13667.13.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/17/2013 01:59 PM, Matthew Garrett wrote:
> On Wed, 2013-04-17 at 11:37 -0400, Kyle Evans wrote:
>> On 04/16/2013 12:26 PM, Matthew Garrett wrote:
>>> Can you try this patch?
>>>
>> No dice. I have a dmi check patch that I will send in a day or two if
>> you don't find what you are looking for.
> DMI's almost certainly the wrong solution. According to your DSDT, EC
> register 0xe6 is called SFHK. That's written to by the SSHK method,
> which in turn is executed by SHKS which should be called by the
> hp_wmi_query call added there. Any chance you can try to figure out why
> that's not happening?
>

I see, I don't know how I missed that before. I think because I was 
searching for e6 instead of E6. I'm sure we can crack this the right way 
now. I'll do some digging.
