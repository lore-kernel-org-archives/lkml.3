Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3DXJhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:37:51 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36153 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3DXJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130423151511.GR5019@opensource.wolfsonmicro.com>
References: <1366614565-3743-1-git-send-email-ks.giri@samsung.com>
	<1366614565-3743-2-git-send-email-ks.giri@samsung.com>
	<20130423151511.GR5019@opensource.wolfsonmicro.com>
Date: Wed, 24 Apr 2013 15:07:47 +0530
Message-ID: <CAKrE-KcGecFNnyKj9AdDYwBOw_OO4o_V2DMjHmYX092fh4EQgw@mail.gmail.com>
Subject: Re: [PATCH 1/3] spi: s3c64xx: added support for polling mode
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 8:45 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Apr 22, 2013 at 12:39:23PM +0530, Girish K S wrote:
>> From: Girish K S <girishks2000@gmail.com>
>>
>> The 64xx spi driver supports partial polling mode.
>> Only the last chunk of the transfer length is transferred
>> or recieved in polling mode.
>
> This appears to have a very noticable negative impact on SPI performance
> on my S3C6410 based system.  Not delved into it to test why but are you
> sure it's not mistakenly selecting polling?

If forced to polling you should see this message "Unable to get SPI rx
dma resource. Switching to poll mode". same if Tx dma resource is not
available from platform data.
Anyways let me cross check again on my tested systems.
