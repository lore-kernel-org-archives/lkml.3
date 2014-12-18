Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaLRQnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:43:05 -0500
Received: from smtp-out-208.synserver.de ([212.40.185.208]:1108 "EHLO
	smtp-out-208.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLRQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:43:03 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10448
Message-ID: <5493040F.5020206@metafoo.de>
Date: Thu, 18 Dec 2014 17:42:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [RFC PATCH 1/2] iio: kfifo: Remove unused argument in iio_kfifo_allocate
References: <1418153385-18212-1-git-send-email-k.wrona@samsung.com> <1418153385-18212-2-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1418153385-18212-2-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:29 PM, Karol Wrona wrote:
> indio_dev was unused in function body plus some small style fix - add new
> lines after "if(sth) return sth" and before the last return statement.

Looks good, except for the missing updates for the users.

Doing some digging in the git history raveled that the user of that 
parameter in that function was removed in commit f79a909890 
("staging:iio:buffer struct iio_buffer doesn't need an indio_dev pointer.")
