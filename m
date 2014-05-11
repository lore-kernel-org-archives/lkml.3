Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbaEKLAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 07:00:19 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50976 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaEKLAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 07:00:16 -0400
Date: Sun, 11 May 2014 13:55:46 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Paul Davies C <pauldaviesc@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/3] Enclose complex macro with parantheses in
 staging/octeon-usb/octeon-hcd.c
Message-ID: <20140511105546.GC6670@drone.musicnaut.iki.fi>
References: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
 <1399795703-6681-3-git-send-email-pauldaviesc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399795703-6681-3-git-send-email-pauldaviesc@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 11, 2014 at 01:38:22PM +0530, Paul Davies C wrote:
> Complex macro is enlosed with parantheses.

This patch breaks compilation. I'll send patches to remove the whole macro.

A.
