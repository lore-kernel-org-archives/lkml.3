Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3J3Tej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:34:39 -0400
Received: from mout.gmx.net ([212.227.17.20]:61929 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab3J3Teh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:34:37 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tpm/tpm_i2c_stm_st33: Check return code of get_burstcount (fix CID: 986658)
Date: Wed, 30 Oct 2013 20:38:04 +0100
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de> <201310300142.11716.PeterHuewe@gmx.de> <20131030030747.GA12179@kroah.com>
In-Reply-To: <20131030030747.GA12179@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310302038.04122.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:xY1MX+kqDS+P6k06VV87Rx0tHitL6zeAOCeAdJS7S8is8uCKdSW
 hQrB1Hrnsr8HaSorPDKO91wCFsmYGZVmhyP0/SZw6pVM8/74CgWY7mo1tZnDISgWBQsgqe/
 TzTSSsgrZ7JQw/zw2JQfUvv3H/i8JKofqcH4OFPUaY5LmXIr/QrbNXeeFTGzEJ3ezelzMMg
 xsmzVyZsPYztIPycgmQKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
 
> It [the CID] is noise as not everyone can see it or make anything out of it, 
> so please don't include it.

I'll remove it from my tree before sending out the pull request to James.
Thanks for your opinion.

Peter

