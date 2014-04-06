Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaDFK23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 06:28:29 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56527 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbaDFK20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 06:28:26 -0400
Message-ID: <1396780101.30640.21.camel@x220>
Subject: Re: [GIT PULL] clk: changes for 3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Turquette <mturquette@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 12:28:21 +0200
In-Reply-To: <20140404174715.8250.22335@quantum>
References: <20140404174715.8250.22335@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 10:28:24.0819 (UTC) FILETIME=[F103CC30:01CF5182]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 10:47 -0700, Mike Turquette wrote:
> Haojian Zhuang (3):
>       [...]
>       clk: hip04: add clock driver

This clock driver is only built if CONFIG_ARCH_HIP04 is set. But I
couldn't find a Kconfig symbol ARCH_HIP04. (I checked master of Linus'
tree and current linux-next.)

Is the code to add this symbol queued somewhere?


Paul Bolle

