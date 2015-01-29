Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbbA2M0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:26:16 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:58755 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbbA2M0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:26:15 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA26E4.5020004@mev.co.uk>
Date: Thu, 29 Jan 2015 12:26:12 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/02] STAGING: Fix pcl818.c coding style issue: code
 indent should use tabs where possible
References: <20150129053316.GA2508@thunderCat>
In-Reply-To: <20150129053316.GA2508@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/15 05:33, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - code indent should use tabs where possible
> It is fixed by reformatting the comment block to usual comment style.
>
> And with the reformatting, following coding style problem is also fixed:
> - please, no space before tabs
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 189 +++++++++++++++-----------------
>   1 file changed, 91 insertions(+), 98 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
