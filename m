Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaJWCCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:02:06 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58198 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaJWCCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:02:03 -0400
Date: Wed, 22 Oct 2014 21:02:13 -0500
From: Brian Vandre <bvandre@gmail.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, gregkh@linuxfoundation.org,
        jic23@kernel.org, alexandre.belloni@free-electrons.com,
        linux-iio@vger.kernel.org, marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
Message-ID: <20141023020213.GA30907@brian-U>
References: <cover.1413858979.git.bvandre@gmail.com>
 <cover.1413931615.git.bvandre@gmail.com>
 <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
 <20141022042115.GA2530@sudip-PC>
 <54484219.5000708@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54484219.5000708@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:47:37AM +0200, Hartmut Knaack wrote:
> Sudip Mukherjee schrieb am 22.10.2014 06:21:
> > On Tue, Oct 21, 2014 at 05:56:47PM -0500, Brian Vandre wrote:
> >> This fixes the 2 checkpatch.pl warnings:
> >> WARNING: line over 80 characters
> >>
> > please check your patch with --strict option of checkpatch.pl , and you will get :
> > "Alignment should match open parenthesis" .
> > 
> Good point, but what solution would you propose?

Hey All,

Thanks for all the feedback.  This is my first attempt at a patch so I thank you all
for helping me through it.  I have a question about the strict option on checkpatch.pl.
I thought that the stict option was not necessarily part of the coding standards but
more of a nice to have.  Should I be always using the strict option?

On this particular patch if I were to align to the open parenthesis it would push the
comment "/* trigger DELAY unit#3 */" off to the next line which I thought we be less
clear.  If --strict is optional then I would argue to leave it the way it is, but again
this is my first time and I am learning.

If I were to align to the parenthesis should I just move the comment to the next line
or possibly delete the comment altogether?  The code is clear and the comment might not
be necessary but I didn't want to remove anything the original author wrote.

Thanks,
Brian Vandre
