Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaIIS64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:58:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57801 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbaIIS6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:58:54 -0400
X-Sasl-enc: 2GoF1qye8OfNK9937E+RxelF7v8YfUN8wIo34dH5HeL2 1410289133
Date: Tue, 9 Sep 2014 11:58:52 -0700
From: Greg KH <greg@kroah.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "James E . J . Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/3] parisc/uapi: Add definition of TIOC[SG]RS485
Message-ID: <20140909185852.GA7037@kroah.com>
References: <1410285991-24833-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140909184318.GA6231@kroah.com>
 <CAPybu_3wJ+UPbnkWPFLJdne6Rz8ouUap3E1GeA9NqX=gP4fPug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_3wJ+UPbnkWPFLJdne6Rz8ouUap3E1GeA9NqX=gP4fPug@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:46:48PM +0200, Ricardo Ribalda Delgado wrote:
> Hello Greg.
> 
>  I have just resend one for sparc. Are we sure that we prefer the
> macros instead of using the same value on all arches?

Why would using a macro preclude the value being the same on all arches?
