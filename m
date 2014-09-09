Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaIITCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:02:54 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:49819 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIITCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140909185852.GA7037@kroah.com>
References: <1410285991-24833-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140909184318.GA6231@kroah.com> <CAPybu_3wJ+UPbnkWPFLJdne6Rz8ouUap3E1GeA9NqX=gP4fPug@mail.gmail.com>
 <20140909185852.GA7037@kroah.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 9 Sep 2014 21:02:31 +0200
Message-ID: <CAPybu_3zhVvS9WzWHsBTFOeNp0VZ2Lx0LxKgDOKoe2zxzNqcNQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] parisc/uapi: Add definition of TIOC[SG]RS485
To: Greg KH <greg@kroah.com>
Cc: "James E . J . Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

I have just resend the macros for the two other arches using the proper macros.

Thanks

On Tue, Sep 9, 2014 at 8:58 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Sep 09, 2014 at 08:46:48PM +0200, Ricardo Ribalda Delgado wrote:
>> Hello Greg.
>>
>>  I have just resend one for sparc. Are we sure that we prefer the
>> macros instead of using the same value on all arches?
>
> Why would using a macro preclude the value being the same on all arches?



-- 
Ricardo Ribalda
