Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3DMMhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 08:37:11 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:56810 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab3DMMhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 08:37:10 -0400
Message-ID: <51695169.6090306@gmail.com>
Date: Sat, 13 Apr 2013 08:36:57 -0400
From: Kyle Evans <kvans32@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>
In-Reply-To: <1365816906.13667.6.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, sorry about that. I was hoping the GUID would be enough. I'll see 
what I can come up with.

On 04/12/2013 09:35 PM, Matthew Garrett wrote:
> On Sat, 2013-04-13 at 03:31 +0200, Pali Rohár wrote:
>
>> all Fn keys, wifi switch, web and mute buttons not working anymore
>> on my notebook HP EliteBook 8460p. I bisected git commit which
>> broke all above keys: fabf85e3ca15d5b94058f391dac8df870cdd427a
>>
>> When I reverted that commit after reboot buttons started working
>> again. Can you fix it or revert that broken commit? This is
>> critical problem, which caused my notebook to be unusable...
> Sure, I'll revert that. Kyle, can you look into figuring out a way to
> only run this on machines that need it?
>

