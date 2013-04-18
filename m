Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3DRGV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:21:59 -0400
Received: from smtp1.u-psud.fr ([129.175.33.41]:62473 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab3DRGV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:21:58 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2013 02:21:58 EDT
Message-ID: <516F8F4B.1000504@lri.fr>
Date: Thu, 18 Apr 2013 08:14:35 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bing Zhao <bzhao@marvell.com>, linux-netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Stewart <pstew@chromium.org>
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>  (sfid-20130418_000709_842159_3005786A) <1366236590.8217.64.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366236590.8217.64.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/2013 00:09, Johannes Berg wrote:
> On Wed, 2013-04-17 at 15:06 -0700, Bing Zhao wrote:
>> Add a "wireless/nl80211_iftype" entry in the net device sysfs
>> file structure to indicate the mode of the wireless device so
>> it can be discovered easily from userspace.
> 
> What's wrong with "iw dev", i.e. netlink/nl80211?

"Do NOT screenscrape this tool, we don't consider its output stable."

So if you are in a shell script, you're basically screwed.
