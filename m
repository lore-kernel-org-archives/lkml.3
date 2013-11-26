Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3KZADK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:03:10 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19276 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3KZADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:03:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Nov 2013 16:00:45 -0800
Message-ID: <5293E53A.5050103@nvidia.com>
Date: Mon, 25 Nov 2013 16:03:06 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: clk: clk_round_rate() should return 0, not negative numbers,
 upon error
References: <alpine.DEB.2.02.1311251553080.23090@tamien> <20131126000153.GY16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131126000153.GY16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:01 PM, Russell King - ARM Linux wrote:
> On Mon, Nov 25, 2013 at 03:55:33PM -0800, Paul Walmsley wrote:
>> Update the documentation for clk_round_rate() to state that it should
>> return 0 rather than a negative error code when it encounters an
>> error.  This describes how the common clock framework currently works;
>> howeever, some clock code does not yet align to this.
>>
>> This change is to prepare for returning unsigned values from
>> clk_round_rate().
> You really ought to document why this is being changed here, to help
> sell the change to parties who are not aware of the background.
> Otherwise, it just looks like a gratuitous API change.

Will do and resend.

- Paul
