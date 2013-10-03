Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3JCPYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:24:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47031 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3JCPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:24:01 -0400
Message-ID: <524D8C0B.90707@wwwdotorg.org>
Date: Thu, 03 Oct 2013 09:23:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: PLLE spread spectrum control
References: <1380209654-25458-1-git-send-email-pdeschrijver@nvidia.com> <524B28EA.40702@wwwdotorg.org> <20131003105228.GK3973@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131003105228.GK3973@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 04:52 AM, Peter De Schrijver wrote:
> On Tue, Oct 01, 2013 at 09:56:26PM +0200, Stephen Warren wrote:
>> On 09/26/2013 09:34 AM, Peter De Schrijver wrote:
>>> Add spread spectrum control for PLLE in Tegra114.
>>
>> It would be useful to have some description of the end-user-visible
>> benefit of this change; why is it useful?
> 
> spread spectrum clocking is a technique to reduce EMI caused by the clock
> signal by modulating the frequency with a low frequency signal. This should
> reduce interference with eg. Wifi or cellular modems on the same board.

Great. The intent of my request was for that information to be included
in the patch description.

