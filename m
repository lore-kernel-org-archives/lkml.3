Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbbAFKIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:08:45 -0500
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:39031 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbbAFKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:08:41 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54ABB425.1080207@mev.co.uk>
Date: Tue, 06 Jan 2015 10:08:37 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Piotr Kubus <p.t.kubus@gmail.com>
CC: Konrad Zapalowicz <bergo.torino@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: dmm32at: Fixed a code indent issue
References: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com> <20150104223129.GF25819@t400> <20150105192406.GA2686@PiotrekLap> <20150106060226.GA4285@sudip-PC>
In-Reply-To: <20150106060226.GA4285@sudip-PC>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 06:02, Sudip Mukherjee wrote:
> On Mon, Jan 05, 2015 at 08:24:06PM +0100, Piotr Kubus wrote:
>> On Sun, Jan 04, 2015 at 11:31:29PM +0100, Konrad Zapalowicz wrote:
>>> On 01/04, Piotr Kubus wrote:
>>>> This is a patch to the dmm32at.c file that fixes up a code indent error found by the checkpatch.pl tool.
>>>
>>> Nice however improve your commit message. The rule is that the lines
>>> should wrap at 72nd column except for quoted material such as compiler
>>> output, etc...
>>>
>>> The 72-character columns are important for allowing quoting and they
>>> play nicely with standard indentation from git log.
>>
>> Hey,
>>
>> I couldn't find that rule in Kernel documentation. Besides there were no
>> complaints from checkpatch.pl tool.
>
> Please check SubmittingPatches in Documentation. It says:
> 'the "summary" must be no more than 70-75 characters'

In this case, it's not the "summary" that's at issue, it's the body of 
the commit message, as Konrad mentioned above.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
