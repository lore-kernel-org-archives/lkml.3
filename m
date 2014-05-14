Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaENROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:14:30 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33534 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaENRO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:14:26 -0400
Date: Wed, 14 May 2014 13:14:23 -0400
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Remove deprecated system_nrt[_freezable]_wq
Message-ID: <20140514171423.GF15690@htj.dyndns.org>
References: <002101cf6f31$18262f30$48728d90$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002101cf6f31$18262f30$48728d90$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:58:06PM +0900, Jingoo Han wrote:
> system_nrt[_freezable]_wq were deprecated by 3b07e9c ("workqueue:
> deprecate system_nrt[_freezable]_wq") and have been deprecated
> for a long time. In addition, these are not used anymore. So,
> let's remove these functions.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied to wq/for-3.16.

Thanks.

-- 
tejun
