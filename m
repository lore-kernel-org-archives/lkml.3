Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3CNLV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:21:26 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:60274 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688Ab3CNLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:21:25 -0400
Message-ID: <1363260079.1335.63.camel@x61.thuisdomein>
Subject: Re: [PATCH] caif: remove caif_shm
From: Paul Bolle <pebolle@tiscali.nl>
To: Erwan Yvin <erwan.yvin@stericsson.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sjur Brendeland <sjur.brendeland@stericsson.com>
Date: Thu, 14 Mar 2013 12:21:19 +0100
In-Reply-To: <1362736584-21115-1-git-send-email-erwan.yvin@stericsson.com>
References: <1362736584-21115-1-git-send-email-erwan.yvin@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 11:21:20.0025 (UTC) FILETIME=[0D4EC890:01CE20A6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 10:56 +0100, Erwan Yvin wrote:
> caif_shm is an old implementation

And it has been unbuildable since release v3.5, due to commit
29746f48d1b2e903b23daf8cc951fcb47ff0110e ("ARM: ux500: delete U5500
support").

> caif_shm will be replaced by caif_virtio
> 
> Signed-off-by: Erwan Yvin <erwan.yvin@stericsson.com>
> Acked-by: Sjur Brendeland <sjur.brandeland@stericsson.com>


Paul Bolle

