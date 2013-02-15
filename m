Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3BOTkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:40:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50673 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3BOTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:40:51 -0500
Message-ID: <511E8F3F.5010202@wwwdotorg.org>
Date: Fri, 15 Feb 2013 12:40:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>, swarren@nvidia.com,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: remove warning dump if timeout happen in
 transfer
References: <1360845813-11334-1-git-send-email-ldewangan@nvidia.com> <20130215191826.GC4351@the-dreams.de>
In-Reply-To: <20130215191826.GC4351@the-dreams.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 12:18 PM, Wolfram Sang wrote:
> On Thu, Feb 14, 2013 at 06:13:33PM +0530, Laxman Dewangan wrote:
>> If timeout error occurs in the i2c transfer then it was dumping warning
>> of call stack.
>>
>> Remove the warning dump as there is may be possibility that some slave
>> devices are busy and not responding the i2c communication.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> I'd like to have the patch extended. Currently, i2c-tegra is the only
> I2C user of BUG and BUG_ON. Could you maybe extend the patch to handle
> those situations more gracefully while we are at it? From a glimpse,
> these situations don't need a complete halt of the kernel?

While that's probably useful, surely that's a separate patch?

