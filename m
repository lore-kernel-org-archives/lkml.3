Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaGRESV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:18:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43333 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaGREST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:18:19 -0400
X-Sasl-enc: vjXEnJM6RRSmt/8Pz7k/r/mE0rAzyp8UT/EK3AvT8TRm 1405657097
Date: Thu, 17 Jul 2014 21:18:16 -0700
From: Greg KH <greg@kroah.com>
To: Derrick Pallas <pallas@meraki.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Derrick Pallas <derrick@pallas.us>
Subject: Re: Linux 3.4.95 breaks LZO tests (additional pull needed)
Message-ID: <20140718041816.GB32696@kroah.com>
References: <CAFqNYV4_yW60oKmb4edH8CQtFiyT491eWOPheBrDse9j-jCYZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqNYV4_yW60oKmb4edH8CQtFiyT491eWOPheBrDse9j-jCYZg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 08:57:56PM -0700, Derrick Pallas wrote:
> An LZO update was backported in Linux 3.4.95 but fails to work if
> crypto tests are enabled. It turns out that
> 0ec7382036922be063b515b2a3f1d6
> f7a607392c, which updates the test vectors, did not come along for the
> ride. Thanks, ~Derrick

Ah, many thanks, I'll go queue that up.

greg k-h
