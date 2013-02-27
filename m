Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3B0KTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:19:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:24127 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3B0KTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:19:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,746,1355126400"; 
   d="scan'208";a="268439696"
Date: Wed, 27 Feb 2013 10:19:06 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 54/86] drm/i915: Set i9xx sdvo clock limits according to
 specifications
Message-ID: <20130227101906.GB1924@cantiga.alporthouse.com>
References: <20130226235912.881663118@linuxfoundation.org>
 <20130226235918.530615135@linuxfoundation.org>
 <CAMeQTsadxx_hEkJ0Jd5wHp2UNERh1+c5Z-VV-Zi4=xz=VJ3d+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMeQTsadxx_hEkJ0Jd5wHp2UNERh1+c5Z-VV-Zi4=xz=VJ3d+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:11:38AM +0100, Patrik Jakobsson wrote:
> On Wed, Feb 27, 2013 at 1:08 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> >
> > commit 4f7dfb6788dd022446847fbbfbe45e13bedb5be2 upstream.

> Is this really stable material? It fixes no known issues and the bug
> report seems to be a different problem.

https://bugs.freedesktop.org/show_bug.cgi?id=59066 is a genuine bug
fixed.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
