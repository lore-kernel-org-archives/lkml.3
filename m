Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaJQQdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:33:19 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45215 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaJQQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:33:18 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5440F282.8040306@itdev.co.uk>
References: <5440F282.8040306@itdev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Touch processing on host CPU
From: Jonathan Cameron <jic23@kernel.org>
Date: Fri, 17 Oct 2014 17:33:01 +0100
To: Nick Dyer <nick.dyer@itdev.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <A82E1F59-BB34-40EA-A13F-456EBCC0519D@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On October 17, 2014 11:42:10 AM GMT+01:00, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
>Hi-
>
>I'm trying to find out which subsystem maintainer I should be talking
>to -
>apologies if I'm addressing the wrong people.
>
>There is a model for doing touch processing where the touch controller
>becomes a much simpler device which sends out raw acquisitions (over
>SPI 
>at up to 1Mbps + protocol overheads). All touch processing is then done
>in
>user space by the host CPU. An example of this is NVIDIA DirectTouch -
>see:
>http://blogs.nvidia.com/blog/2012/02/24/industry-adopts-nvidia-directtouch/
>
>In the spirit of "upstream first", I'm trying to figure out how to get
>a
>driver accepted. Obviously it's not an input device in the normal
>sense. Is
>it acceptable just to send the raw touch data out via a char device? Is
>there another subsystem which is a good match (eg IIO)?

Possibly... 
> Does the
>protocol
>(there is ancillary/control data as well) need to be documented?

Do you know of a suitable ADC frontend?  Preferably with docs. Interesting bit is the
 data format and these ancillary parts.
>
>cheers

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
