Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaJWN1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:27:39 -0400
Received: from down.free-electrons.com ([37.187.137.238]:60654 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbaJWN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:27:37 -0400
Date: Thu, 23 Oct 2014 15:27:34 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Brian Vandre <bvandre@gmail.com>
Cc: gregkh@linuxfoundation.org, jic23@kernel.org, linux-iio@vger.kernel.org,
        marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
Message-ID: <20141023132733.GB10477@piout.net>
References: <cover.1413858979.git.bvandre@gmail.com>
 <cover.1413931615.git.bvandre@gmail.com>
 <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
 <20141023125336.GB10433@brian-U>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023125336.GB10433@brian-U>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 23/10/2014 at 07:53:36 -0500, Brian Vandre wrote :
> With all the replies I have gotten it seems like there might not be a good path forward
> with this patch.  I am starting to agree with what Daniel Baluta said above that this doesn't
> make the code easier to read.  All the other suggestions don't quite fit the same style
> as the rest of the file so it might just be better to leave it.
> 
> This being my first try I thank you all for your input.  It has helped me learn quite a bit.
> 
> Hopefully on the next patch I can fix something a little more meaningful!
> 

Thank you for your effort anyway. My last comment would be that you
don't need a cover letter when sending only one patch.

There are plenty of things to fix in the kernel, maybe we can help you
find something.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
