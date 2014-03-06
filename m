Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaCFVtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:49:12 -0500
Received: from nm14-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.164]:39358 "EHLO
	nm14-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbaCFVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:49:06 -0500
X-Yahoo-Newman-Id: 516403.1817.bm@smtp206.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mTMsJEcVM1kEqEJIiZ_X3eDqbAEcz.rRI5SZlnDH.vnTKUQ
 3yIBOIAlpAAxOMGOUN9COwArrDQU9nLOu1ZuepJhRR6Hz0FZ5CCBgrTXNAQp
 IxGNes64BThZ2_iE.cj7BGvA8ByVFJdvrUc.2ejzloYrb7U1ejzlDoT7toMY
 FAkfS94Rf0G_zNl0k5fH_xnW.0CEpqen93kCrI4sCJZyzj8bAPCt60hqSdn3
 TjzZgmUbbGNo3lixITm2Eu6ZfndXCyDmK4tcpVRE6bc2B54xlXcotUqNZGMe
 FKIREC1wvnFrzrQNKyeUhaFbjj6Sf7NRwQ2IRJOfIjSfKOE.mRBJuQvKVQh7
 Efh8jQv5bmbE3u_6oOSMBUjH6RWDPZUyuPjaho2UP0ff9ba8VbfoCVWTylYQ
 xzNE_He9zUPdgCqGfY743o7FM2F9YjnJ8PD0tS6weRrG64sTPrdeD1AesGDi
 cK2uYLSmarkRypgNsyYlFkPn3seN6gBHw0XsJQ8wtGNhjdmv1J37miEpNf1I
 lMozgwklh.t1YTBQBpxr7u0_0.9NTJdlFRKFoZsAZRC90v2uY3QDUdVXxRFu
 xAOXIagVhglEtBKdIdH4adjTNvDjUu4nBMhY7huK4xZ2o5BKQaTOmqKj47Cx
 jp_ZHOYVonlObLjK4i.jYXIScyvTyxC.J0Y.NTBMmuVjGIG_ReXJUaA--
X-Yahoo-SMTP: u9r3j8eswBBsV5z1r5v0bR9cjPS77vatbJK.6sw-
X-Rocket-Received: from [163.238.113.35] (draconicpenguin1@163.238.113.35 with plain [98.139.211.125])
        by smtp206.mail.bf1.yahoo.com with SMTP; 06 Mar 2014 13:49:05 -0800 PST
Message-ID: <5318ED51.4060400@yahoo.com>
Date: Thu, 06 Mar 2014 16:49:05 -0500
From: Brian Wong <draconicpenguin1@yahoo.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Re: Hyper-V Synthetic Video Frame Buffer Driver may distort top two
 lines of console
References: <5318DD7A.2080706@yahoo.com> <5318E311.8000303@yahoo.com>
In-Reply-To: <5318E311.8000303@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2014 4:05 PM, Brian Wong wrote:
> On 3/6/2014 3:41 PM, Brian Wong wrote:
>> I've identified another possible bug in the Hyper-V drivers: When the
>> Hyper-V Synthetic Video Frame Buffer Driver is built into the kernel,
>> and the VM is paused and continued, the top two lines of the console may
>> become distorted. See the image at http://imgur.com/kIExFP3.
>>
>> Can someone look into it?
>
> Just to clarify, I can confirm this bug under both the patched Gentoo
> 3.10.32 kernel and the vanilla 3.13.5 kernel (see the image at
> http://imgur.com/mYUTzgt). Is the framebuffer somehow getting corrupted?
>

The problem also reproduces under Kali Linux with kernel 3.12.6, but 
only on virtual consoles that are not hosting a graphical X session. The 
problem does not appear in X.

-- 
Brian Wong
http://www.fierydragonlord.com
