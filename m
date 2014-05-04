Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaEDTso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:48:44 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58355 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaEDTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140503235233.GA7976@kroah.com>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
	<20140428094005.GU26890@mwanda>
	<20140503235233.GA7976@kroah.com>
Date: Sun, 4 May 2014 14:48:42 -0500
Message-ID: <CA+jnaaV2imbeqemt-_BUoKnWOUGFW_j1z0nK_QWQXNpnHOakvw@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: comedi: addi_apci_1564: remove eeprom
 support code
From: Chase Southwood <chase.southwood@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2014 at 6:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 28, 2014 at 12:40:05PM +0300, Dan Carpenter wrote:
>> Nice, Chase, you've become an expert on comedi, it seems.
>>
>> I can't say how happy comedi patches make me these days.  Ian, you and
>> Hartley are doing a fantastic job.
>
> Same here, it's great to see all of this cleanup happening.  Maybe
> someday it can move out of staging...  :)

Thanks everyone! :) Yeah, I suppose it would be nice to see comedi
graduate, eh?  AFAICT, it looks like it's been hanging around in
staging a while...

Thanks,
Chase
