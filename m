Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaGVCrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:47:46 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:14834 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaGVCrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:47:45 -0400
Date: Tue, 22 Jul 2014 04:47:40 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, oleg.drokin@intel.com,
        jinshan.xiong@intel.com, lai.siyao@intel.com, joe@perches.com,
        bergwolf@gmail.com, john.hammond@intel.com, sachin.kamat@linaro.org
Subject: Re: [PATCH] staging: llite: rw.c: use gfp_t to store GFP flags
Message-ID: <20140722024740.GA25961@bender.morinfr.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Guillaume Morin <guillaume@morinfr.org>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, oleg.drokin@intel.com,
	jinshan.xiong@intel.com, lai.siyao@intel.com, joe@perches.com,
	bergwolf@gmail.com, john.hammond@intel.com, sachin.kamat@linaro.org
References: <22be101821a4af2c92ca597832cbb720c655418e.1405990074.git.guillaume@morinfr.org>
 <20140722020805.GA19215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722020805.GA19215@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Jul 19:08, Greg KH wrote:
> Odd thing is, that function doesn't seem to even use that variable
> anywhere...  Can you just remove it entirely?

Oh that's right.  Resubmitted.

Thanks

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
