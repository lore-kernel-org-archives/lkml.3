Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab3DYN0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:26:38 -0400
Received: from plane.gmane.org ([80.91.229.3]:36663 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab3DYN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:26:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,551,1363158000"; 
   d="scan'208";a="232295097"
From: Andi Kleen <andi@firstfloor.org>
To: Karel Zak <public-kzak-H+wXaHxf7aLQT0dZR+AlfA@plane.gmane.org>
Cc: public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-util-linux-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org
Subject: Re: [ANNOUNCE] util-linux 2.23
References: <20130425110450.GF2244@x2.net.home>
Date: Thu, 25 Apr 2013 06:25:03 -0700
In-Reply-To: <20130425110450.GF2244@x2.net.home> (Karel Zak's message of "Thu,
	25 Apr 2013 13:04:50 +0200")
Message-ID: <m2haiuvj2o.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> Util-linux 2.23 Release Notes
> =============================
>
> The cryptoloop support in the commands mount(8) and losetup(8) has been
> REMOVED. The encryption= mount option and -e,-E,--encryption losetup options
> are no more supported.

That's crazy. You're taking away access to existing data.

-Andi

