Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaCPOzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 10:55:03 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:42989 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaCPOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 10:55:00 -0400
Date: Sun, 16 Mar 2014 10:54:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: Re: linux-next: ahci_platform broken build
Message-ID: <20140316145457.GA26026@htj.dyndns.org>
References: <5325AFB2.4050505@canonical.com>
 <5325B1A3.9070102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5325B1A3.9070102@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2014 at 03:13:55PM +0100, Hans de Goede wrote:
> Tejun it is probably easiest if you fix this up directly in your tree, let me know if you
> want a fixed up resend of the 2 patches in question instead.

It already happened and got resolved in the span of few patches.  Shit
happens.  Let's just try to test each step better next time.

Thanks.

-- 
tejun
