Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaCFKes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:34:48 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64608 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFKeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:34:44 -0500
Date: Thu, 6 Mar 2014 18:33:50 +0800
From: Wang YanQing <udknight@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: plagnioj@jcrosoft.com, fengguang.wu@intel.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: uvesafb: use CONFIG_X86_PAE surround
 _PAGE_NX check code
Message-ID: <20140306103349.GA11701@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, plagnioj@jcrosoft.com,
	fengguang.wu@intel.com, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140305161611.GA32461@udknight>
 <53184655.2090106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53184655.2090106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 11:56:37AM +0200, Tomi Valkeinen wrote:
> I don't like this, I think this makes the code more messy, just to avoid
> that warning.
> 
> And it might even be buggy. For your patch to work correctly, you need
> to know the internals of _PAGE_NX, i.e. that when CONFIG_X86_PAE is not
> defined, _PAGE_NX is 0. But the driver should not depend on things like
> that. If _PAGE_NX is changed later, the driver will not work correctly.
> 

Very right! Thanks.




