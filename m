Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbAIVyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:54:08 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:57782 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbbAIVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:54:06 -0500
Date: Fri, 9 Jan 2015 16:54:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Use dev_info() to inform about the lack of Device
 Sleep support
Message-ID: <20150109215401.GG2785@htj.dyndns.org>
References: <1420742494-5017-1-git-send-email-gabriele.mzt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420742494-5017-1-git-send-email-gabriele.mzt@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 07:41:34PM +0100, Gabriele Mazzotta wrote:
> According to the Serial ATA AHCI specification, Device Sleep is an
> optional feature and as such no errors should be printed if it's
> missing. Keep informing users, but use dev_info() instead of dev_err().

Does this condition actually occur?  The cap's advertise that the
controller does DEVSLP but the port register doesn't have it?

Thanks.

-- 
tejun
