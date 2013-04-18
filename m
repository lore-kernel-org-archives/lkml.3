Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab3DRBoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 21:44:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:54846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DRBoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 21:44:21 -0400
Message-ID: <516F4FE7.4070309@infradead.org>
Date: Wed, 17 Apr 2013 18:44:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2013-04-17-16-02 uploaded (gpu/drm/qxl)
References: <20130417230333.4A9E15A4206@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20130417230333.4A9E15A4206@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/13 16:03, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-04-17-16-02 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 


I saw this in linux-next a few days ago and forgot to post it.

When CONFIG_DEBUG_FS is not enabled:


drivers/gpu/drm/qxl/qxl_ttm.c:568:33: error: 'qxl_mm_dump_table' undeclared (first use in this function)
drivers/gpu/drm/qxl/qxl_debugfs.c:76:2: error: implicit declaration of function 'drm_debugfs_create_files' [-Werror=implicit-function-declaration]
drivers/gpu/drm/qxl/qxl_debugfs.c:84:2: error: implicit declaration of function 'drm_debugfs_remove_files' [-Werror=implicit-function-declaration]


-- 
~Randy
