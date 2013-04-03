Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3DCTzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:55:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48204
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932245Ab3DCTzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:55:36 -0400
Date: Wed, 3 Apr 2013 21:55:29 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 0/3] mtip32xx: recovery improvement and fix for a crash
Message-ID: <20130403195529.GD4667@kernel.dk>
References: <515C3B1C.8020801@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515C3B1C.8020801@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03 2013, Asai Thambi S P wrote:
> Hi Jens,
> 
> This patchset includes the following. It was generated against your for-3.9/drivers
> 
> * improved recovery for command timeout
> * fix for a crash during rmmod
> * add new debugfs entry 'device_status'
> 
> 
> Asai Thambi S P (3):
>   mtip32xx: recovery from command timeout
>   mtip32xx: return 0 from pci probe in case of rebuild
>   mtip32xx: Add debugfs entry device_status

Thanks Asai, applied for current series.

-- 
Jens Axboe

