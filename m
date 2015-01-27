Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbbA0QDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:03:43 -0500
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:47359 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbbA0QDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:03:41 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C7B6D9.3080306@mev.co.uk>
Date: Tue, 27 Jan 2015 16:03:37 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 01/02] STAGING: Fix pcl818.c coding style issue:
 code indent should use tabs where possible
References: <20150126165822.GA10112@thunderCat>
In-Reply-To: <20150126165822.GA10112@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Stripped a non-fully-qualified 'To:' address from the reply.]

On 26/01/15 16:58, Simon Guo wrote:
>
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
