Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaBJTDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:03:36 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:58614 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbaBJTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:03:35 -0500
Date: Mon, 10 Feb 2014 13:03:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: gregkh@linuxfoundation.org, penberg@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] slub: do not drop slab_mutex for sysfs_slab_add
In-Reply-To: <ba4769896e7b5702679e4d7a7ab53dd5aa370e74.1391942582.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1402101302510.17405@nuc>
References: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com> <ba4769896e7b5702679e4d7a7ab53dd5aa370e74.1391942582.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Feb 2014, Vladimir Davydov wrote:

> Fortunately, recently kobject_uevent was patched to call the usermode
> helper with the UMH_NO_WAIT flag, making the deadlock impossible.

Great!!!! If you can get that other patch merged then

Acked-by: Christoph Lameter <cl@linux.com>

