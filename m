Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3HXXdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 19:33:22 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61291 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3HXXdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 19:33:21 -0400
Date: Sat, 24 Aug 2013 16:33:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] Input: gameport: convert bus code to use drv_groups
Message-ID: <20130824233318.GB4454@core.coreip.homeip.net>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
 <1377293081-10957-7-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377293081-10957-7-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 02:24:33PM -0700, Greg Kroah-Hartman wrote:
> The drv_attrs field of struct bus_type is going away soon, drv_groups
> should be used instead.  This converts the gameport bus code to use the
> correct field.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I assume you'll be taking the entire series through your tree?

Thanks.

-- 
Dmitry
