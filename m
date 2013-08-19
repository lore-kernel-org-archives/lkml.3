Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883Ab3HSGTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:19:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3HSGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:19:07 -0400
Message-ID: <5211B8C2.1010702@oracle.com>
Date: Mon, 19 Aug 2013 14:18:42 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Vaughan Cao <vaughan.cao@oracle.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] xen: initialize xen panic handler for PVHVM
References: <1376640656-32381-1-git-send-email-vaughan.cao@oracle.com> <20130816124327.GC10190@konrad-lan.dumpdata.com>
In-Reply-To: <20130816124327.GC10190@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 20:43, Konrad Rzeszutek Wilk wrote:
> Could you tell me what has been happening without this patch?

Without this patch, Xen would not get pvhvm crash event, any config for
on_crash in guest configure file will not be triggered.

Thanks,
Joe

