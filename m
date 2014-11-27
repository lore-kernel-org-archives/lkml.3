Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaK0FaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:30:20 -0500
Received: from syn.loicp.eu ([176.31.96.212]:59429 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaK0FaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:30:18 -0500
Date: Thu, 27 Nov 2014 06:30:12 +0100
From: =?utf-8?B?TG/Dr2M=?= Pefferkorn <loic@loicp.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, gdonald@gmail.com,
        keith.mannthey@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warnings related to lock
 context imbalance
Message-ID: <20141127053012.GA9725@iron>
References: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
 <20141126205443.GB10615@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141126205443.GB10615@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:54:43PM -0800, Greg KH wrote:
> 
> Ugh, how horrid, please just delete these functions and push down the
> spin_lock/unlock calls down into the places these are called.
>
> Same for these.
> 
> Same thing here.

Hello Greg,

Thanks for your comments, I will write a v2.

-- 
Cheers,
Loic
