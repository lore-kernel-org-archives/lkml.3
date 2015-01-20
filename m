Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbbATLkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbbATLki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:40:38 -0500
Date: Tue, 20 Jan 2015 11:40:33 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: nick <xerofoify@gmail.com>
Cc: agk@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND] md:Remove no longer needed fix me
	comment in dm-region-hash.c for removing the structure pointer, *rh
	from the definiton of dm_region
Message-ID: <20150120114032.GC17599@agk-dp.fab.redhat.com>
Mail-Followup-To: nick <xerofoify@gmail.com>, agk@redhat.com,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, snitzer@redhat.com
References: <1421723781-21984-1-git-send-email-xerofoify@gmail.com> <20150120111951.GB17599@agk-dp.fab.redhat.com> <54BE3DAA.5080900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE3DAA.5080900@gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 06:36:10AM -0500, nick wrote:
> Unless we use a union or something similar there seems to be no easy 
> way without rewriting a lot of an already function driver file.

The comment does not restrict itself to 'easy ways'.

Alasdair


