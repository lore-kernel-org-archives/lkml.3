Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3FDMOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:14:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3FDMOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:14:38 -0400
Message-ID: <51ADDA24.7050609@redhat.com>
Date: Tue, 04 Jun 2013 14:14:28 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Libo Chen <libo.chen@huawei.com>
CC: megaraidlinux@lsi.com, JBottomley@parallels.com,
        Libo Chen <chenlibo.3@gmail.com>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com,
        aradford@gmail.com, Li Zefan <lizefan@huawei.com>,
        Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v2] scsi: megaraid: check kzalloc
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com> <51ADB484.3060404@huawei.com>
In-Reply-To: <51ADB484.3060404@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 11:33 AM, Libo Chen wrote:
> we should check kzalloc, avoid to hit oops
>
> Change from v1:
> - put kzalloc outside of mutex
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Your patch looks fine to me:
Acked-by: Tomas Henzl <thenzl@redhat.com>

Cheers,
Tomas

