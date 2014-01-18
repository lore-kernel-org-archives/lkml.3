Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaARVGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 16:06:08 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:55606 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbaARVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 16:06:07 -0500
Message-ID: <1390079163.25980.2.camel@x41>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sat, 18 Jan 2014 22:06:03 +0100
In-Reply-To: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2014 21:06:04.0433 (UTC) FILETIME=[194D1810:01CF1491]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjarke Istrup Pedersen schreef op za 18-01-2014 om 20:48 [+0000]:
> This patch adds the hyperv.h header to the uapi folder, and adds it to the Kbuild file.
> Doing this enables compiling userspace Hyper-V tools using the installed headers.
> 
> Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
> ---
>  include/uapi/linux/Kbuild   |    1 +
>  include/uapi/linux/hyperv.h | 1469 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 1470 insertions(+)
>  create mode 100644 include/uapi/linux/hyperv.h

Now we have two identical files: include/linux/hyperv.h and
include/uapi/linux/hyperv.h. That seems sub-optimal at best.


Paul Bolle

