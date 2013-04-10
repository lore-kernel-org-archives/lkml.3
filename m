Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3DJGKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:10:32 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60412 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3DJGKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:10:30 -0400
Date: Tue, 9 Apr 2013 23:10:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Toshi Kani <toshi.kani@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v2 1/3] resource: Add __adjust_resource() for internal
 use
In-Reply-To: <1365440996-30981-2-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.02.1304092310170.3916@chino.kir.corp.google.com>
References: <1365440996-30981-1-git-send-email-toshi.kani@hp.com> <1365440996-30981-2-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013, Toshi Kani wrote:

> Added __adjust_resource(), which is called by adjust_resource()
> internally after the resource_lock is held.  There is no interface
> change to adjust_resource().  This change allows other functions
> to call __adjust_resource() internally while the resource_lock is
> held.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
