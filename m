Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaAWUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:48:22 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:50767 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbaAWUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:48:21 -0500
Date: Thu, 23 Jan 2014 14:48:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mel Gorman <mgorman@suse.de>
cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
In-Reply-To: <20140122151913.GY4963@suse.de>
Message-ID: <alpine.DEB.2.10.1401231447500.8031@nuc>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com> <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com> <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com> <20140122151913.GY4963@suse.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Mel Gorman wrote:

> Don't get me wrong, I'm interested in the topic but I severely doubt I'd
> have the capacity to research the background of this in advance. It's also
> unlikely that I'd work on it in the future without throwing out my current
> TODO list. In an ideal world someone will have done the legwork in advance
> of LSF/MM to help drive the topic.

I can give an overview of the history and the challenges of the approaches
if needed.

