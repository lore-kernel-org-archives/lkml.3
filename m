Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab3CTBuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:50:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47070 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700Ab3CTBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:50:21 -0400
Message-ID: <514915DB.8060206@wwwdotorg.org>
Date: Tue, 19 Mar 2013 19:50:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: fuse: add fuctions to read speedo id and
 process id
References: <1363660405-10668-1-git-send-email-dahuang@nvidia.com>  <5148A8D6.8000002@wwwdotorg.org> <1363743557.3573.50.camel@dahuang-vm>
In-Reply-To: <1363743557.3573.50.camel@dahuang-vm>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 07:39 PM, Danny Huang wrote:
> On Wed, 2013-03-20 at 02:05 +0800, Stephen Warren wrote:
>> On 03/18/2013 08:33 PM, Danny Huang wrote:
>>> Add functions to read the speedo and process id of both cpu and soc.
>>> There might be some drivers need the information as well.
>>
>> What code wants to use these functions? It'd be best to submit this
>> patch with that code, so that something actually uses the functions, and
>> they don't look like dead code.
> 
> There are some developing drivers that are located in drivers folder
> needs those information.

Which drivers?

> I think that they can't include a header file in mach-tegra folder

True.
