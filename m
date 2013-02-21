Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3BUFnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:43:13 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:37757 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3BUFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:43:12 -0500
Date: Thu, 21 Feb 2013 09:43:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, xemul@parallels.com, hpa@zytor.com,
        Alexander Kartashov <alekskartashov@parallels.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [patch 2/2] arm: Wire up kcmp syscall
Message-ID: <20130221054308.GA1740@moon>
References: <20130219064800.719149796@openvz.org>
 <20130219065210.148067470@openvz.org>
 <20130219070703.GC20312@moon>
 <20130220151723.0a22794a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220151723.0a22794a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 03:17:23PM -0800, Andrew Morton wrote:
> On Tue, 19 Feb 2013 11:07:03 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > From: Alexander Kartashov <alekskartashov@parallels.com>
> > Subject: arm: Wire up kcmp syscall
> > 
> > Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> This should have had signed-off-by:you, as you were on the patch's
> delivery path.

Ouch, sorry Andrew! Thanks!
