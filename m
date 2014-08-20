Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaHTLQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:16:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaHTLQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:16:18 -0400
Date: Wed, 20 Aug 2014 06:15:37 -0500
From: gregkh <gregkh@linuxfoundation.org>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>, jic23@kernel.org,
        linux-iio@vger.kernel.org, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio
Message-ID: <20140820111537.GA12663@kroah.com>
References: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>
 <53F441FF.9090304@metafoo.de>
 <CAGUYZuSENkSjoA9U0E8MQKp0a1J3moE8p8NYAzfiZ+BpxND4Aw@mail.gmail.com>
 <53F4451B.3040209@metafoo.de>
 <CAGUYZuQwKMG0OFt_gJVPTj3EWin68Jg3jzD9T_Rje-UroOCf=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGUYZuQwKMG0OFt_gJVPTj3EWin68Jg3jzD9T_Rje-UroOCf=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Aug 20, 2014 at 12:32:52PM +0530, sanjeev sharma wrote:
> Hi,
> 
> I have only moved some header files because other header files are already
> present there and these are only pending files which is not moved outside the
> staging directory.
> 
> @Greg:What is your though on this ?

Lars-Peter is correct, don't "leak" files from staging.  Take the time
to work on fixing up these drivers correctly so they can be moved out of
staging instead of just doing simple file moves which do nothing.

greg k-h
