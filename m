Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaAHXzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:55:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaAHXzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:55:39 -0500
Date: Wed, 8 Jan 2014 15:56:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: MonamAgarwal <monamagarwal123@gmail.com>
Cc: rashika.kheria@gmail.com, peter.p.waskiewicz.jr@intel.com,
        andreas.dilger@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: lustre: Fix return does not need parantheses
Message-ID: <20140108235609.GA15093@kroah.com>
References: <52c9be03.c394420a.7a22.36eb@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52c9be03.c394420a.7a22.36eb@mx.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:48:07AM +0530, MonamAgarwal wrote:
> This patch fixes the following checkpatch.pl warning in
> lustre/ldlm/interval_tree.c
> ERROR: return is not a function, parentheses are not required
> 
> Signed-off-by: MonamAgarwal <monamagarwal123@gmail.com>

I need a semblance of a "real" name, which usually consists of a first
and last name for most places.

thanks,

greg k-h
