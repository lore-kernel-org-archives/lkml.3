Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3LEUl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:41:59 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47670 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3LEUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:41:57 -0500
Date: Thu, 5 Dec 2013 12:41:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matt Walker <matt.g.d.walker@gmail.com>
Cc: backports@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] drivers/input/mouse: add support for newer elantech
 touchpads (released ca. August 2013);
Message-ID: <20131205204150.GA2761@core.coreip.homeip.net>
References: <CA+X2d=AHdivGF+s_uOC2ns5okoOdZHX1kEg4iuB32zUkBjsszg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+X2d=AHdivGF+s_uOC2ns5okoOdZHX1kEg4iuB32zUkBjsszg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 12:57:15PM -0500, Matt Walker wrote:
> From: Matt Walker <matt.g.d.walker@gmail.com>
> 
> Added detection for newer Elantech touchpads, so that kernel doesn't
> fall-back to default PS/2 driver. Supports touchpads released after
> ~August 2013.  Fixes bug:
> https://lists.launchpad.net/kernel-packages/msg18481.html
> 
> Signed-off by: Matt Walker <matt.g.d.walker@gmail.com> on an Acer
> Aspire S7-392-6302

Applied, thank you.

> 
> ----
> 
> Thanks to Hauke for the reference on how to submit a patch properly.
> Thanks to Dmitry for correction to Signed-off line.
> 
> Diff Output:
> 
> --- linux-3.13-rc1/drivers/input/
> mouse/elantech.c.orig    2013-12-03
> 12:14:52.829173656 -0500
> +++ linux-3.13-rc1/drivers/input/mouse/elantech.c    2013-12-03
> 12:15:11.833173880 -0500
> @@ -1313,6 +1313,7 @@ static int elantech_set_properties(struc
>              break;
>          case 6:
>          case 7:
> +        case 8:
>              etd->hw_version = 4;
>              break;
>          default:



-- 
Dmitry
