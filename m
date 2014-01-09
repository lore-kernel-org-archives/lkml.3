Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaAIKKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:10:40 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:43447 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaAIKKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:10:32 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 05:10:32 EST
Date: Thu, 9 Jan 2014 10:52:04 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH, RFC 13/30] cris: sync_serial: remove
 interruptible_sleep_on
Message-ID: <20140109095203.GS15831@axis.com>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
 <1388664474-1710039-14-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388664474-1710039-14-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 01:07:37PM +0100, Arnd Bergmann wrote:
> sleep_on and its variants are racy and going away. This replaces
> the two uses in the cris sync_serial drivers with the equivalent
> but race-free wait_event_interruptible.

Looks good, pulling it into the cris tree for 3.14.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
