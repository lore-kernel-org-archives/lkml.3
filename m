Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3EBIDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:03:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39859
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab3EBIDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:03:41 -0400
Date: Thu, 2 May 2013 10:03:25 +0200
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 1/8] rsxx: Adding in debugfs entries.
Message-ID: <20130502080325.GF7800@kernel.dk>
References: <20130502002317.GA29619@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502002317.GA29619@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01 2013, Philip J. Kelleher wrote:
>  #define NO_LEGACY 0
> +#define DEBUGFS_NULL NULL
>  
> +static struct dentry *rsxx_debugfs_root = DEBUGFS_NULL;

What's the point of DEBUGFS_NULL?

-- 
Jens Axboe

