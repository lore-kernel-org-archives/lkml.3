Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaHLLOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:14:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51597 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbaHLLOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:14:10 -0400
Date: Tue, 12 Aug 2014 13:14:07 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Rob Clark <robdclark@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] drm: rework flip-work framework
Message-ID: <20140812131407.069635e8@bbrezillon>
In-Reply-To: <1405173968-23869-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405173968-23869-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 12 Jul 2014 16:06:06 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch series reworks the flip-work framework to make it safe when
> calling drm_flip_work_queue from atomic contexts.
> 
> The 2nd patch of this series is optional, as it only reworks
> drm_flip_work_init prototype to remove unneeded size argument and
> return code (this function cannot fail anymore).


Atmel HLCDC driver now depends on this series and I'd like to get as
much thing as possible for HLCDC support in 3.18 (if the driver can't
make it for 3.18, at least the dependencies could).

David, Rob (and other DRM/KMS developers) do you have any concern you
would like addressed in this patch series ?

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
