Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3J2VQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:16:04 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:59423 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab3J2VQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:16:02 -0400
Message-ID: <1383081359.22833.21.camel@x220.thuisdomein>
Subject: Re: Revert 9745cdb36da83aeec198650b410ca06304cf792 ("select: use
 freezable blocking call")?
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Colin Cross <ccross@android.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Oct 2013 22:15:59 +0100
In-Reply-To: <52702170.7080003@intel.com>
References: <1383075705.22833.18.camel@x220.thuisdomein>
	 <52702170.7080003@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2013 21:16:00.0580 (UTC) FILETIME=[112C2840:01CED4EC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 21:58 +0100, Rafael J. Wysocki wrote:
> On 10/29/2013 8:41 PM, Paul Bolle wrote:
> > 4) Should this commit be reverted? Or is there a better fix?
> 
> In short, yes, it should.
> 
> I've already queued up a revert of something very similar and I'm going 
> to revert this one too.

If you do, the revert should go into stable for v3.11+ too, shouldn't
it?

Thanks,


Paul Bolle

