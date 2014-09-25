Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaIYUAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:00:18 -0400
Received: from mout.gmx.net ([212.227.15.15]:54476 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbaIYUAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:00:16 -0400
Message-ID: <54247446.4030200@gmx.de>
Date: Thu, 25 Sep 2014 22:00:06 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: linux@arm.linux.org.uk
Subject: Re: [PATCH v3 11/17] parisc: io: implement dummy relaxed accessor
 macros for writes
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <1411579056-16966-12-git-send-email-will.deacon@arm.com>
In-Reply-To: <1411579056-16966-12-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:xODZfRRF4mIHPUk7zl1mFrHWAOp2cg405hKFm3KD9W+6UgF1pWZ
 n98hXwA+0vmFVtqcou5LGI2Pj4dC0tXRjqW5Axh+5g8iY4iqycshvGkYKD4OdIULAMEGsPu
 PcUJlRTiCkLToXRHXTXVDQvufU1o45xcmPCyQ830qbpTH6wmIOdOZr1xoYndbsMUYyza9BW
 4AWDdviLsqs+PV1ivCl2Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 07:17 PM, Will Deacon wrote:
> This patch adds dummy macros for the write accessors to parisc, in the
> same vein as the dummy definitions for the relaxed read accessors.
>
> Cc: Helge Deller <deller@gmx.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>   arch/parisc/include/asm/io.h | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)

Acked-by: Helge Deller <deller@gmx.de>

Thanks!
Helge
