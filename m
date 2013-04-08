Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235Ab3DHSFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:05:24 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40239 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762938Ab3DHSFW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:05:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Luis Henriques <luis.henriques@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 8 Apr 2013 11:03:32 -0700
Subject: RE: [PATCH 054/102] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Thread-Topic: [PATCH 054/102] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Thread-Index: Ac40Pq3fcp6x9zP6QoOnODTFp1LdPwARJbFw
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE9605C@SC-VEXCH1.marvell.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
 <1365414657-29191-55-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <1365414657-29191-55-git-send-email-luis.henriques@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> 3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bing Zhao <bzhao@marvell.com>
> 
> commit 084c7189acb3f969c855536166042e27f5dd703f upstream.
> 
> curr_cmd points to the command that is in processing or waiting
> for its command response from firmware. If the function shutdown
> happens to occur at this time we should cancel the cmd timer and
> put the command back to free queue.
> 
> Tested-by: Marco Cesarano <marco@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

This patch is intended for kernel 3.8+.
Please drop it from linux-3.5.7.10 stable.

Thanks,
Bing
