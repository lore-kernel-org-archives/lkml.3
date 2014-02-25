Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaBYH6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:58:55 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343AbaBYH6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:58:53 -0500
Message-ID: <530C4D13.7000000@free-electrons.com>
Date: Tue, 25 Feb 2014 08:58:11 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
References: <CA+V-a8tn54CcaFEBMM48GMnTuG=OhQtxm7=od_4OZm6Xo_S9qA@mail.gmail.com> <1386584182-5400-1-git-send-email-michael.opdenacker@free-electrons.com> <4210530.AR5GZgidVz@avalon> <53060055.2010408@free-electrons.com> <CA+V-a8s2RFiqENVk2mR4dQ92ZhvB93BcyMLy0cX3eZkns5HRaQ@mail.gmail.com> <CA+V-a8sQk8oRiTWpLhfQQCkibe2FCOz=opb+Ge1R-ig4ZqrdFw@mail.gmail.com>
In-Reply-To: <CA+V-a8sQk8oRiTWpLhfQQCkibe2FCOz=opb+Ge1R-ig4ZqrdFw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar

On 02/25/2014 07:02 AM, Prabhakar Lad wrote:
> Hi Michael,
>
> On Mon, Feb 24, 2014 at 11:01 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> Hi Michael,
>>
>> On Thu, Feb 20, 2014 at 6:47 PM, Michael Opdenacker
>> <michael.opdenacker@free-electrons.com> wrote:
>>> Hi Laurent,
>>>
>>> On 02/20/2014 12:36 PM, Laurent Pinchart wrote:
>>>> Hi Michael,
>>>>
>>>> What's the status of this patch ? Do expect Prabhakar to pick it up, or do you
>>>> plan to push all your IRQF_DISABLED removal patches in one go ?
>>> It's true a good number of my patches haven't been picked up yet, even
>>> after multiple resends.
>>>
>>> I was planning to ask the community tomorrow about what to do to finally
>>> get rid of IRQF_DISABLED. Effectively, pushing all the remaining changes
>>> in one go (or removing the definition of IRQF_DISABLED) may be the final
>>> solution.
>>>
>>> I hope to be able to answer your question by the end of the week.
>>>
>> gentle ping. should I pick it up ?
>>
> I've picked it up.
>
> Thanks,
> --Prabhakar Lad

Thanks a lot! Yes, I was planning to wait for another cycle before
sending a treewide patch.

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

