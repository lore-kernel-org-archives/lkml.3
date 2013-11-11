Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3KKQYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:24:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50813 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3KKQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:24:17 -0500
Message-ID: <528104AD.9030102@wwwdotorg.org>
Date: Mon, 11 Nov 2013 09:24:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Kumar Gala <galak@codeaurora.org>
CC: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: Re: common location for devicetree files
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org> <20131108165255.GA32668@titan.lakedaemon.net> <5957C301-9698-45B0-BFED-749DE79D0A74@codeaurora.org> <20131108181351.GF10335@titan.lakedaemon.net> <2274FB81-099B-4206-8332-70E9824FFF2F@codeaurora.org> <20131108183240.GH10335@titan.lakedaemon.net>
In-Reply-To: <20131108183240.GH10335@titan.lakedaemon.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 11:32 AM, Jason Cooper wrote:
> On Fri, Nov 08, 2013 at 12:17:30PM -0600, Kumar Gala wrote:
> ...
>> I get the point, just not sure how else to sort the 800+ .dts{i} files
>> that we have in the kernel tree right now.
> 
> Well, to start with, all #include'd files could go into a
> arch/dts/include directory.  That would clean things up a bit.
> 
> We could also consider separating the dts files by ISA.  All armv7 in
> one directory, armv8, armv5te, powerpc, mips, etc.

It's quite likely people will want to share some significant *.dtsi
across multiple architectures.
