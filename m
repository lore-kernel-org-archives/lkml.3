Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3AKN1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:27:06 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41769
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590Ab3AKN1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:27:04 -0500
Message-ID: <50F01322.3070606@kernel.dk>
Date: Fri, 11 Jan 2013 14:26:58 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: Re: [PATCH 0/3] mtip32xx: add trim support and couple of fixes
References: <50F00FF1.1090804@micron.com>
In-Reply-To: <50F00FF1.1090804@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-11 14:13, Asai Thambi S P wrote:
> 
> This patch series contain changes for trim support and couple of fixes
> 
> Asai Thambi S P (3):
>   mtip32xx: add trim support
>   mtip32xx: fix for driver hang after a command timeout
>   mtip32xx: fix for crash when the device surprise removed during
>     rebuild

Thanks. I will apply 1/3 to the 3.9 branch, and 2-3/3 to the 3.8
for-linus branch.

-- 
Jens Axboe

