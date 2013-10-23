Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3JWLPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:15:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38579 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3JWLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:15:37 -0400
X-Spam-Score: -100.8
Message-ID: <5267AF98.1010800@asianux.com>
Date: Wed, 23 Oct 2013 19:14:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joern Rennecke <joern.rennecke@embecosm.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com> <52673E41.6040606@asianux.com>
In-Reply-To: <52673E41.6040606@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 11:10 AM, Chen Gang wrote:
> On 10/23/2013 10:48 AM, Joern Rennecke wrote:
>>
>> That just means that the image is too large to allow conditional
>> pc-relative calls (tail/sibcalls) or otherwise.
>>
>> You can avoid generating them for functions with out a relevant
>> attribute with -mmedium-calls .
>>

After try, it is OK (pass compiling), and I will continue the arc kernel
and try to finish allmodconfig cross compiling.

Thanks again.

> OK, thanks, I will/should try (it should be OK).
> 
> BTW: after pass this, kernel may pass the whole cross compiling with
> allmodconfig (the other 2 gcc issues, can reconstruct source code to
> bypass).
> 

-- 
Chen Gang
