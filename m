Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbbAQXkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:40:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbAQXkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:40:35 -0500
Date: Sat, 17 Jan 2015 15:23:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arjun AK <arjunak234@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ft1000: Fix code style issue
Message-ID: <20150117232328.GA27041@kroah.com>
References: <1420615625-25738-1-git-send-email-arjunak234@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420615625-25738-1-git-send-email-arjunak234@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 12:57:05PM +0530, Arjun AK wrote:
> Remove unnecessary braces from single statement blocks.
> 
> Signed-off-by: Arjun AK <arjunak234@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 101 ++++++++---------------
>  1 file changed, 35 insertions(+), 66 deletions(-)

Doesn't apply to my staging-testing tree :(
