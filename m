Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693Ab3DJVgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:36:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:52550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3DJVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:36:31 -0400
Message-ID: <5165DB54.90508@infradead.org>
Date: Wed, 10 Apr 2013 14:36:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: linux-next: Tree for Apr 10 (meda and OF)
References: <20130410184852.92a3a02bbe5c3a040be76365@canb.auug.org.au>
In-Reply-To: <20130410184852.92a3a02bbe5c3a040be76365@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/13 01:48, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130409:
> 


on i386:

ERROR: "of_get_next_parent" [drivers/media/v4l2-core/videodev.ko] undefined!


'of_get_next_parent()' should be exported for use by modules...?


-- 
~Randy
