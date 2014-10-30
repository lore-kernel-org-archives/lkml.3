Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbaJ3JzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:55:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:33481 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbaJ3JzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:55:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 10:51:29 +0100
Message-ID: <54520A21.20404@samsung.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com> <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-api@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 217-67-201-162.itsa.net.pl
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
In-Reply-To: <20141029234001.GB16520@kroah.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-30 00:40, Greg Kroah-Hartman wrote:

> There is a 1815 line documentation file in this series, so we aren't
> trying to not provide this type of information here at all.  But yes,
> more background, about why this can't be done in userspace (zero copy,
> less context switches, proper credential passing, timestamping, availble
> at early-boot, LSM hooks for security models to tie into

While you're at it... I have worked on proof-of-concept LSM patches for
kdbus some time ago, see [1][2].  Currently, these are completely of date.

 [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
 [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40

May I ask if you guys have your own plan for LSM or maybe it would be
worth to resurrect [1]?

Cheers,
-- 
Karol Lewandowski, Samsung R&D Institute Poland


