Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbbA0QEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:04:20 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:59224 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758483AbbA0QES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:04:18 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C7B6FF.3050203@mev.co.uk>
Date: Tue, 27 Jan 2015 16:04:15 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 02/02] STAGING: Fix pcl818.c coding style issue:
 line over 80 characters
References: <20150126165921.GB10112@thunderCat>
In-Reply-To: <20150126165921.GB10112@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/15 16:59, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - line over 80 characters
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
