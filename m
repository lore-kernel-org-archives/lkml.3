Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3EFPb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:31:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:51025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3EFPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:31:25 -0400
Message-ID: <1367854279.8434.13.camel@jlt4.sipsolutions.net>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 17:31:19 +0200
In-Reply-To: <20130506153044.GB1602@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	 <20130506123805.GA1602@redhat.com>
	 <20130506083759.556dac76@chukar.edge2.net>
	 <20130506153044.GB1602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 17:30 +0200, Stanislaw Gruszka wrote:

> I thought this happen because 4965 firmware does not mark tx status
> ack for PROBE_REQUEST frame, because it is not acked by standard 
> ACK frame, but by PROBE_RESPONSE frame.

Actually, it is ACKed normally, but also gets a probe response :-)

(Or do we send it as multicast? I don't think we do)

> But if so, I would also see
> the breakage on my setup, but I don't - it works quite well here. 

Are you testing on a passive channel? Try with a large beacon interval.

johannes

