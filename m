Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaBFNc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:32:57 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58635 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbaBFNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:32:55 -0500
Message-ID: <52F38F41.4030607@gmail.com>
Date: Thu, 06 Feb 2014 14:33:53 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <52F33BE7.2040607@gmail.com> <2240387.gpLEHJv4c1@vostro.rjw.lan>
In-Reply-To: <2240387.gpLEHJv4c1@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 01:40 PM, Rafael J. Wysocki wrote:
> On Thursday, February 06, 2014 08:38:15 AM Francis Moreau wrote:
>> Hi,
>>
>> On 02/06/2014 12:42 AM, Bastien Traverse wrote:
>>> Hello,
>>>
>>> I'm encountering the exact same problem (same model of machine, same
>>> controller, same OS) and was wondering where this bug was at.
>>
>> I'm still leaving with this issue since my initial posting unfortunately :(
>>
>> I'm wondering why PM support on this machine is so crapish (it initialy
>> oopsed when resuming due to a bug in rtsx driver).
> 
> Is this a new problem in 3.12?
> 

I don't know, sorry, maybe Bastien has an idea.


