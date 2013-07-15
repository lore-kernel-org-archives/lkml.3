Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3GORNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:13:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3GORNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:13:23 -0400
Message-ID: <51E42DB0.8090006@wwwdotorg.org>
Date: Mon, 15 Jul 2013 11:13:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Enable lm90 in Tegra30 and Tegra114.
References: <1373615364-18559-1-git-send-email-wni@nvidia.com> <51E427F1.9010106@wwwdotorg.org>
In-Reply-To: <51E427F1.9010106@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 10:48 AM, Stephen Warren wrote:
> On 07/12/2013 01:49 AM, Wei Ni wrote:
>> Enable thermal sensor lm90 for Tegra30 Cardhu and Tegra114 Dalmore.
> 
> I have applied the series to Tegra's for-3.12/dt branch.

Actually, I see the following on Dalmore (although Cardhu works):

[   29.448539] lm90 0-004c: Register 0x4 read failed (-121)
[   29.453930] lm90 0-004c: Failed to read convrate register!
[   29.460034] lm90 0-004c: Register 0x3 read failed (-121)
[   29.465408] lm90 0-004c: Initialization failed!

So, there's something wrong here, and I've dropped the patch for
Dalmore. Does this patch actually work for you?
