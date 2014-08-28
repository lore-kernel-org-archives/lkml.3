Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913AbaH1Gys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:54:48 -0400
Received: from mblankhorst.nl ([141.105.120.124]:58877 "EHLO mblankhorst.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933987AbaH1Gyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:54:47 -0400
Message-ID: <53FED20D.3030506@canonical.com>
Date: Thu, 28 Aug 2014 08:54:05 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sumit Semwal <sumit.semwal@linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Colin Cross <ccross@google.com>, John Stultz <john.stultz@linaro.org>,
        devel@driverdev.osuosl.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/2] android: add sync_fence_create_dma
References: <53EC8722.4070407@canonical.com> <53EC876C.9050705@canonical.com> <20140815064656.GB20920@kroah.com>
In-Reply-To: <20140815064656.GB20920@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On 15-08-14 08:46, Greg Kroah-Hartman wrote:
> On Thu, Aug 14, 2014 at 11:54:52AM +0200, Maarten Lankhorst wrote:
>> This allows users of dma fences to create a android fence.
> 
> Who is going to use these functions?  I need an in-kernel user before I
> can add new api calls.

So I found a in-kernel user and PATCH 1/2 fixes a mem-leak with android out of tree drivers, and android's in-kernel sw-sync.
Will you apply these patches?

~Maarten
