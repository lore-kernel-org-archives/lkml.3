Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaKEVid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:38:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKEVia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:38:30 -0500
Date: Wed, 05 Nov 2014 16:38:25 -0500 (EST)
Message-Id: <20141105.163825.1433973842938441546.davem@davemloft.net>
To: gerlitz.or@gmail.com
Cc: therbert@google.com, joestringer@nicira.com, netdev@vger.kernel.org,
        sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com,
        linux.nics@intel.com, amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/5] Implement ndo_gso_check() for vxlan nics
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAJ3xEMhxabp1EKbFPfvoZEFt=CQKFNcNrURGMX=7miDwmK9Y-A@mail.gmail.com>
References: <CANr6G5xtNYenhd8KDWx+kRcnSZ0fahUdAL+6Wcz=5_dNvrQR6Q@mail.gmail.com>
	<CA+mtBx_BOmV+tOtio48M+xRatK79B31LoGnf4uvFJAbxYqOt_w@mail.gmail.com>
	<CAJ3xEMhxabp1EKbFPfvoZEFt=CQKFNcNrURGMX=7miDwmK9Y-A@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 13:38:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Or Gerlitz <gerlitz.or@gmail.com>
Date: Wed, 5 Nov 2014 23:32:44 +0200

> but fact is that the proposed patch series has the --same-- helper for
> four drivers, so why not start with a that limited helper which would
> be picked up by these drivers and we'll take it from there.

I'm in favor of the helper, duplication is error prone.

And in fact, any differences a driver ends up needing might be
integratable into the helper.
