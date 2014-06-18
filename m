Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaFRTBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:01:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34673 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754249AbaFRTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:01:24 -0400
Date: Wed, 18 Jun 2014 20:01:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140618190108.GI32514@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:54:24PM +0200, Pali Rohár wrote:
> Machine name from board description is some generic name on DT kernel.
> DT provides machine name property which is specific for board, so use
> it instead generic one when possible.

http://archive.arm.linux.org.uk/lurker/message/20130726.132850.53d47576.en.html

"If userspace wants to get at the DT information about a platform, we already
have ways that can happen already - we export the DT stuff so that kexec's
tools can get at it."

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
